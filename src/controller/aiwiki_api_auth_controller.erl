-module(aiwiki_api_auth_controller).
-behaviour(cowboy_handler).
-export([init/2,terminate/3]).
init(Req,State)-> ok.
terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.
