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
  Pager = pagination(PageIndex0,PageCount0,erlang:length(Pages0)),
  aiwiki_view:render(<<"page/index">>,Req,State#{context => #{
    <<"pages">> => Pages0,
    <<"topics">> => Topics,
    <<"pager">> => Pager
  }});
 
init(Req,#{action := show} = State)->
    PageID = cowboy_req:binding(id,Req),
    Title = cowboy_req:binding(title,Req),
    PageID0 = ai_string:to_integer(PageID),
    [Page] = ai_db:find_by(page,[{'or',[{id,PageID0},{title,Title}]}]),
    Page0 = aiwiki_page_model:view(Page),
    Title0 = proplists:get_value(title,Page),
    aiwiki_view:render(<<"page/show">>,Req,State#{context => #{
      <<"title">> => Title0,
      <<"page">> => Page0
    }}).


url(Page)->
  Title = maps:get(<<"title">>,Page),
  ID = maps:get(<<"id">>,Page),
  EncodeTitle = ai_url:urlencode(Title),
  EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
  <<"/pages/",EncodeID/binary,"/",EncodeTitle/binary,".html">>.

pagination(PageIndex,PageCount,Length)->
  PageCount0 = ai_string:to_string(PageCount),
  PageIndex0 = ai_string:to_string(PageIndex - 1),
  PageIndex1 = ai_string:to_string(PageIndex + 1),
  PrevUrl = <<"/pages?pageIndex=",PageIndex0/binary,"&pageCount=",PageCount0/binary>>,
  NextUrl = <<"/pages?pageIndex=",PageIndex1/binary,"&pageCount=",PageCount0/binary>>,
  if
    PageIndex > 0 ->
      if PageCount > Length ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => true,<<"url">> => PrevUrl},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => false}
          ];
        true ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => true,<<"url">> => PrevUrl},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => true,<<"url">> => NextUrl}
          ]
      end;
    true ->
      if 
        PageCount > Length ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => false},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => false}
          ];
        true ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => false},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => true,<<"url">> => NextUrl}
          ]
      end
  end.

