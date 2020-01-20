-module(aiwiki_topic_helper).
-export([aside/2,url/2,select/1]).

select(Idx)->
  Topics = ai_db:find_all(topic),
  lists:map(
    fun(Topic)->
        Topic0 = aiwiki_helper:view_model(Topic),
        TopicIdx = proplists:get_value(id,Topic),
        if
          TopicIdx == Idx ->
            Topic0#{<<"selected">> => true};
          true ->
            Topic0#{<<"selected">> => false}
        end
    end,Topics).

aside(Idx,Title)->
  Topics = ai_db:find_all(topic),
  lists:map(
    fun(Topic)->
        Fields = ai_db_model:fields(Topic),
        Topic0 = aiwiki_helper:view_model(Fields),
        TopicIdx = maps:get(id,Fields),
        TopicTitle = maps:get(title,Fields),
        Topic1 = Topic0#{<<"url">> => url(TopicIdx,TopicTitle)},
        if
          (TopicIdx == Idx) orelse (TopicTitle == Title) ->
            Topic1#{<<"selected">> => true};
          true ->
            Topic1#{<<"selected">> => false}
        end
    end,Topics).

url(Idx,Title)->
  EncodeTopicIdx = ai_string:to_string(Idx),
  EncodeTopicTitle = ai_url:urlencode(Title),
  <<"/topics/",EncodeTopicIdx/binary,"/",EncodeTopicTitle/binary,".html">>.
