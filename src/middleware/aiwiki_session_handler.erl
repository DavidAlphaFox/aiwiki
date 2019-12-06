-module(aiwiki_session_handler).
-export([execute/2]).
-export([create/1,session/1,session_id/1,login/2,login/3]).

execute(Req,_Env)->
    case session_id(Req) of
        undefined -> redirect;
        Session ->
            case has(Session) of
                undefined ->
                    Req0 = cowboy_req:set_resp_cookie(<<"aiwiki.session">>,<<"">>,Req,#{max_age => 0}),
                    {redirect,Req0};
                _ -> true
            end
    end.

session(Req)->
    case session_id(Req) of
        undefined ->undefined;
        Session ->
            case has(Session) of
                undefined-> undefined;
                Email ->
                    {Session,#{<<"email">> => Email}}
            end
    end.



create(Req)->
  Token = token(),
  Req0 = cowboy_req:set_resp_cookie(<<"aiwiki.session">>,
    Token, Req,#{http_only => true}),
  {ok,Token,Req0}.

login(Session,Email)-> login(Session,Email,undefined).
login(Session,Email,Timeout)->
  CacheKey = <<"session:",Session/binary>>,
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

has(Session)->
  CacheKey = <<"session:",Session/binary>>,
  Commands = ["GET",CacheKey],
  try
    {ok,Email} =
      aiwiki_db:run_cache(
        fun(C)->  eredis:q(C, Commands) end),
      Email
  catch
    _Type:_Reason -> undefined
  end.

token()->
  UUID = ai_uuid:uuid_to_string(ai_uuid:get_v4(),binary_standard),
  ai_base64:encode(UUID,#{padding => false}).
