-module(aiwiki_page_controller).
-export([init/2,terminate/3]).
init(Req,#{action := index} = State)->
  QS = cowboy_req:parse_qs(Req),
  PageIndex = proplists:get_value(<<"pageIndex">>,QS,0),
  PageCount = proplists:get_value(<<"pageCount">>,QS,5),
  PageIndex0 = ai_string:to_integer(PageIndex),
  PageCount0 = ai_string:to_integer(PageCount),
  Pages = aiwiki_page_model:pagination(PageIndex0,PageCount0),
  Pages0 = lists:map(fun(M) -> 
      M0 = aiwiki_page_helper:view_model(M),
      Url = aiwiki_page_helper:url(M),
      M0#{<<"url">> => Url}
    end,Pages),
  Topics = aiwiki_topic_helper:aside(undefined,undefined),
  Pager = aiwiki_page_helper:pagination(PageIndex0,PageCount0,erlang:length(Pages0)),
  aiwiki_view:render(<<"page/index">>,Req,State#{context => #{
    <<"pages">> => Pages0,
    <<"topics">> => Topics,
    <<"pager">> => Pager
  }});
 
init(Req,#{action := show} = State)->
    PageID = cowboy_req:binding(id,Req),
    Title = cowboy_req:binding(title,Req),
    {Title1,_} = aiwiki_helper:resource_and_format(Title),
    Title2 = ai_url:urldecode(Title1),
    PageID0 = ai_string:to_integer(PageID),
    [Page] = ai_db:find_by(page,[{'or',[{id,PageID0},{title,Title2}]}]),
    Page0 = aiwiki_page_helper:view_model(Page),
    Title2 = proplists:get_value(title,Page),
    aiwiki_view:render(<<"page/show">>,Req,State#{context => #{
      <<"title">> => Title2,
      <<"page">> => Page0
    }}).


  terminate(normal,_Req,_State) -> ok;
  terminate(Reason,Req,State)->
    Reason0 = io_lib:format("~p~n",[Reason]),
    aiwiki_view:error(500,Reason0,Req,State),
    ok.
