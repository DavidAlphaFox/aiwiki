-module(aiwiki_topic_controller).
-export([init/2,terminate/3]).

init(Req,State)->
  QS = cowboy_req:parse_qs(Req),
  TopicID = cowboy_req:binding(id,Req),
  Topic = cowboy_req:binding(title,Req),
  PageIndex = proplists:get_value(<<"pageIndex">>,QS,0),
  PageCount = proplists:get_value(<<"pageCount">>,QS,5),
  PageIndex0 = ai_string:to_integer(PageIndex),
  PageCount0 = ai_string:to_integer(PageCount),
  TopicID0 = ai_string:to_integer(TopicID),
  {Topic0,_} = aiwiki_helper:resource_and_format(Topic),
  Topic1 = ai_url:urldecode(Topic0),
  [TopicR] = ai_db:find_by(topic,[{'or',[{id,TopicID0},{title,Topic1}]}]),
  TopicID1 = proplists:get_value(id,TopicR),
  Topic2 = proplists:get_value(title,TopicR),
  Pages = aiwiki_page_model:pagination(PageIndex0,PageCount0,TopicID1),
  Pages0 = lists:map(fun(M) -> 
      M0 = aiwiki_page_helper:view_model(M),
      Url = aiwiki_page_helper:url(M0),
      M0#{<<"url">> => Url}
    end,Pages),
  Topics = aiwiki_topic_helper:aside(TopicID1,Topic2),
  Path = cowboy_req:path(Req),
  Pager = aiwiki_helper:pagination(Path,PageIndex0,PageCount0,erlang:length(Pages0)),
  aiwiki_view:render(<<"topic/index">>,Req,State#{context => #{
    <<"pages">> => Pages0,
    <<"topics">> => Topics,
    <<"pager">> => Pager,
    <<"topic">> => aiwiki_helper:view_model(TopicR)
  }}).


terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.
