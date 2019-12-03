-module(aiwiki_auth_handler).
-export([execute/2]).
execute( Req, #{auth := Auth } = Env) ->
  #{exclude := ExcludePath, include := IncludePath} = Auth,
  Path = cowboy_req:path(Req),
  Exclude = 
    lists:any(fun(E)-> 
      case re:run(Path,E) of 
        {match,_} -> true;
        nomatch -> false
      end
    end,ExcludePath),
  execute(Req,Env,Exclude,IncludePath).

execute(Req,Env,true,_IncludePath)->
    {ok,Req,Env};
execute(Req,Env,_,IncludePath)->
  Path = cowboy_req:path(Req),
  Include = 
    lists:any(fun(E)-> 
      case re:run(Path,E) of 
        {match,_} -> true;
        nomatch -> false
      end
    end,IncludePath),
  execute(Req,Env,Include).

execute(Req,Env,true)->
  case session(Req) of 
    undefined -> session(Req,Env,undefined);
    Session -> session(Req,Env,Session)
  end;
execute(Req,Env,_)->
  {ok,Req,Env}.

session(Req)->
  try cowboy_req:parse_cookies(Req) of
    Cookies -> proplists:get_value(<<"aiwiki.session">>,Cookies)
  catch 
    _:_ -> undefined
  end.    
session(Req,#{auth := Auth },undefined)->
  #{to := To} = Auth,
  Req0 = cowboy_req:set_resp_cookie(<<"aiwiki.session">>,<<"">>,Req),
  { stop, cowboy_req:reply( 302, #{ <<"Location">> => To }, Req0 ) };
session(Req,#{auth := Auth } = Env,Session)->
  #{to := To} = Auth,
  case has(Session) of 
    undefined -> 
      Req0 = cowboy_req:set_resp_cookie(<<"aiwiki.session">>,<<"">>,Req),
      { stop, cowboy_req:reply( 302, #{ <<"Location">> => To }, Req0 ) };
    _ ->
      {ok,Req,Env}
  end.


has(Session)->
  CacheKey = <<"session:",Session/binary>>,
  Commands = ["GET",CacheKey],
  try
    {ok,Email} =
      aiwiki_db:run_cache(
          fun(C)->
              eredis:q(C, Commands)
          end),
      Email
  catch
    _Type:_Reason -> undefined      
  end.