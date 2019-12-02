-module(aiwiki_topic_helper).
-export([aside/2,url/2]).

aside(Idx,Title)->
  Topics = ai_db:find_all(topic),
  lists:map(fun(Topic)-> 
    Topic0 = 
      lists:foldl(
        fun({Key,Value},Acc) ->
          Acc#{ai_string:to_string(Key) => Value}
        end,#{},Topic),
    TopicIdx = proplists:get_value(id,Topic),
    TopicTitle = proplists:get_value(title,Topic),

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