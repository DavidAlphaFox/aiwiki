-module(aiwiki_topic_controller).
-export([init/2]).

init(Req,State)->
  QS = cowboy_req:parse_qs(Req),
  {PageIndex,PageCount} = aiwiki_pager_helper:index_and_count(QS),
  {TopicID,Topic} = topic(Req),
  [TopicR] = ai_db:find_by(topic,[{'or',[{id,TopicID},{title,Topic}]}]),
  
  TopicID1 = proplists:get_value(id,TopicR),
  Topic1 = proplists:get_value(title,TopicR),
 
  Topics = aiwiki_topic_helper:aside(TopicID1,Topic1),
  Pages = pages(PageIndex,PageCount,TopicID1),
  Path = cowboy_req:path(Req),
  Pager = aiwiki_pager_helper:build(Path,PageIndex,PageCount,erlang:length(Pages)),
  Context =  #{
    <<"pages">> => Pages,
    <<"topics">> => Topics,
    <<"pager">> => Pager,
    <<"topic">> => aiwiki_helper:view_model(TopicR)
  },
  {ok,<<"topic/index">>,Req,State#{context => Context}}.

topic(Req)->
  TopicID = cowboy_req:binding(id,Req),
  Topic = cowboy_req:binding(title,Req),
  TopicID0 = ai_string:to_integer(TopicID),
  {Topic0,_} = aicow_path:resource_and_format(Topic),
  Topic1 = ai_url:urldecode(Topic0),
  {TopicID0,Topic1}.

pages(PageIndex,PageCount,TopicID)->
  Pages = aiwiki_page_model:pagination(PageIndex,PageCount,TopicID),
  lists:map(fun(M) -> 
      M0 = aiwiki_page_helper:view_model(M),
      Url = aiwiki_page_helper:url(M),
      M0#{<<"url">> => Url}
    end,Pages).