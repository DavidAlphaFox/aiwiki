-module(aiwiki_topic_helper).
-export([aside/2,url/2,select/1]).

select(Idx)->
  Topics = ai_db:find_all(topic),
  lists:map(
    fun(Topic)->
        Topic0 = ai_db_model:fields(Topic),
        TopicIdx = maps:get(id,Topic),
        if
          TopicIdx == Idx ->
            Topic0#{selected => true};
          true ->
            Topic0#{selected => false}
        end
    end,Topics).

aside(Idx,Title)->
  Topics = ai_db:find_all(topic),
  lists:map(
    fun(Topic)->
        Topic0 = ai_db_model:fields(Topic),
        TopicIdx = maps:get(id,Topic0),
        TopicTitle = maps:get(title,Topic0),
        Topic1 = Topic0#{url => url(TopicIdx,TopicTitle)},
        if
          (TopicIdx == Idx) orelse (TopicTitle == Title) ->
            Topic1#{selected => true};
          true ->
            Topic1#{selected => false}
        end
    end,Topics).

url(Idx,Title)->
  EncodeTopicIdx = ai_string:to_string(Idx),
  EncodeTopicTitle = ai_url:urlencode(Title),
  <<"/topics/",EncodeTopicIdx/binary,"/",EncodeTopicTitle/binary,".html">>.
