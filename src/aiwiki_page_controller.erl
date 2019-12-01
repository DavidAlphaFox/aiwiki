-module(aiwiki_page_controller).
-export([init/2]).
init(Req,#{action := index} = State)->
  QS = cowboy_req:parse_qs(Req),
  PageIndex = proplists:get_value(<<"pageIndex">>,QS,0),
  PageCount = proplists:get_value(<<"pageCount">>,QS,5),
  PageIndex0 = ai_string:to_integer(PageIndex),
  PageCount0 = ai_string:to_integer(PageCount),
  Pages = aiwiki_page_model:pagination(PageIndex0,PageCount0),
  Pages0 = lists:map(fun(M) -> 
      M0 = aiwiki_page_model:view(M),
      Url = url(M0),
      M0#{<<"url">> => Url}
    end,Pages),
  Topics = aiwiki_topic_model:aside(1,<<"杂谈"/utf8>>),
  aiwiki_view:render(<<"page/index">>,Req,State#{context => #{
    <<"pages">> => Pages0,
    <<"topics">> => Topics
  }});
  
init(Req,#{action := show} = State)->
    PageID = cowboy_req:binding(id,Req),
    Title = cowboy_req:binding(title,Req),
    PageID0 = ai_string:to_integer(PageID),
    [Page] = ai_db:find_by(page,[{'or',[{id,PageID0},{title,Title}]}]),
    Page0 = aiwiki_page_model:view(Page),
    aiwiki_view:render(<<"page/show">>,Req,State#{context => #{<<"page">> => Page0}}).


url(Page)->
  Title = maps:get(<<"title">>,Page),
  ID = maps:get(<<"id">>,Page),
  EncodeTitle = ai_url:urlencode(Title),
  EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
  <<"/pages/",EncodeID/binary,"/",EncodeTitle/binary,".html">>.
