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

execute(Req,Env,true,_IncludePath)-> {ok,Req,Env};
execute(Req,Env,_,IncludePath)->
  Path = cowboy_req:path(Req),
  Include = 
    lists:search(fun({E,_Module})->
                     case re:run(Path,E) of
                       {match,_} -> true;
                       nomatch -> false
                     end
                 end,IncludePath),
  execute(Req,Env,Include).

execute(Req,Env,{value,{_,Module}})->
  case Module:execute(Req,Env) of
    redirect->  session(Req,Env,redirect);
    {redirect,Req0} -> session(Req0,Env,redirect);
    false -> session(Req,Env,false);
    true -> {ok,Req,Env};
    R -> R
  end;
execute(Req,Env,_)-> {ok,Req,Env}.

session(Req,_Env,false) -> {stop,cowboy_req:reply(401,Req)};
session(Req,#{auth := Auth},redirect)->
  case maps:get(to,Auth,undefined) of
    undefined -> {stop,cowboy_req:reply(401,Req)};
    To -> { stop, cowboy_req:reply( 302, #{ <<"Location">> => To }, Req) }
  end.
