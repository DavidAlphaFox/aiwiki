-module(aiwiki_api_page_controller).
-behaviour(cowboy_handler).
-export([init/2]).
init(Req,State)->
  QS = cowboy_req:parse_qs(Req),
  PageID = proplists:get_value(<<"id">>,QS),
  PageID0 = ai_string:to_integer(PageID),
  Page = ai_db:fetch(page,PageID0),
  aiwiki_view:render_json(data,[{data,Page}],Req,State).

%terminate(normal,_Req,_State) -> ok;
%terminate(Reason,Req,State)->
%  Reason0 = io_lib:format("~p~n",[Reason]),
%  aiwiki_view:error(500,Reason0,Req,State),
%  ok.
