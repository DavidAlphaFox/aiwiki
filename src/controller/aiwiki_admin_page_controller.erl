-module(aiwiki_admin_page_controller).
-behaviour(cowboy_handler).
-export([init/2,terminate/3]).

init(Req,State)->
  Menus = menus(),
  QS = cowboy_req:parse_qs(Req),
  PageIndex = proplists:get_value(<<"pageIndex">>,QS,0),
  PageCount = proplists:get_value(<<"pageCount">>,QS,8),
  PageIndex0 = ai_string:to_integer(PageIndex),
  PageCount0 = ai_string:to_integer(PageCount),
  Pages = aiwiki_page_model:pagination(PageIndex0,PageCount0,undefined,undefined),
  Pages0 = lists:map(fun(M) -> 
      M0 = aiwiki_page_helper:view_model(M),
      Url = url(M0),
      M0#{<<"edit_url">> => Url}
    end,Pages),
  Pager = aiwiki_helper:pagination(<<"/admin/pages.php">>,
    PageIndex0,PageCount0,erlang:length(Pages0)),
  Context = #{
      <<"pages">> => Pages0,
      <<"pager">> => Pager,
      <<"menus">> => Menus
  },
  aiwiki_view:render(<<"admin/page/index">>,Req,State#{context => Context}).

terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.

menus()-> aiwiki_admin_helper:menus(<<"文章"/utf8>>).

url(Page) ->
    ID = maps:get(<<"id">>, Page),
    EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
    <<"/admin/pages/edit.php?id=",EncodeID/binary>>.
