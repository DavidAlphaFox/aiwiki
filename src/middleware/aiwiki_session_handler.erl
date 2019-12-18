-module(aiwiki_session_handler).
-export([execute/2]).
-export([create/1,session/1,session_id/1]).
-export([login/2,login/3,logout/1]).

execute(Req,_Env)->
  case session_id(Req) of
    undefined -> redirect;
    Session ->
      case has(Session) of
        undefined ->
          Req0 = remove_session_id(Req),
          {redirect,Req0};
        _ -> true
      end
  end.

session(Req)->
  case session_id(Req) of
    undefined -> undefined;
    Session ->
      case has(Session) of
        undefined -> {Session,undefined};
        Email -> {Session,Email}
      end
  end.



create(Req)->
  Token = token(),
  Req0 = cowboy_req:set_resp_cookie(<<"aiwiki.session">>,
                                    Token, Req,#{http_only => true,path => <<"/">>}),
  {ok,Token,Req0}.
logout(Req)->
  case session_id(Req) of
    undefined -> Req;
    SessionID ->
      remove(SessionID),
      remove_session_id(Req)
  end.

login(Session,Email)-> login(Session,Email,undefined).
login(Session,Email,Timeout)->
  CacheKey = key(Session),
  Commands =
    case Timeout of
      undefined -> [["SET",CacheKey,Email]];
      _ ->  [
              ["SET",CacheKey,Email],
              ["EXPIRE",CacheKey,Timeout]
            ]
    end,
  try
    aiwiki_db:run_cache(fun(C)-> eredis:qp(C,Commands) end),
    ok
  catch
    _Type:Reason -> {error,Reason}
  end.


session_id(Req)->
  try cowboy_req:parse_cookies(Req) of
      Cookies -> proplists:get_value(<<"aiwiki.session">>,Cookies)
  catch
    _:_ -> undefined
  end.

remove_session_id(Req)->
  cowboy_req:set_resp_cookie(<<"aiwiki.session">>,<<"">>,
                             Req,#{max_age => 0, path => <<"/">>}).


has(Session)->
  Fun = fun(C) ->
            eredis:q(C, [<<"GET">>,key(Session)])
        end,
  try
    {ok,Email} = aiwiki_db:run_cache(Fun),
    Email
  catch
    _Type:_Reason -> undefined
  end.

remove(Session) ->
  Fun = fun(C)->
            eredis:q(C,[<<"DEL">>,key(Session)])
        end,
  catch aiwiki_db:run_cache(Fun).

key(Session) -> <<"aiwiki:session:",Session/binary>>.
  
token()->
  UUID = ai_uuid:uuid_to_string(ai_uuid:get_v4(),binary_standard),
  ai_base64:encode(UUID,#{padding => false}).
