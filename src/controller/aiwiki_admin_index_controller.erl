-module(aiwiki_admin_index_controller).
-behaviour(cowboy_handler).
-export([init/2,terminate/3]).
init(Req,State)->
  Menus = aiwiki_admin_helper:menus(undefined),
  Context = #{
      <<"menus">> => Menus
  },
  aiwiki_view:render(<<"admin/index">>,Req,State#{context => Context}).
terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.
