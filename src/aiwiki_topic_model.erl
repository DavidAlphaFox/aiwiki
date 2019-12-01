-module(aiwiki_topic_model).
-export([sleep/1,wakeup/1,schema/0,attributes/0]).
-export([aside/2]).


sleep(PropList)-> maps:from_list(PropList).
wakeup(Fields)-> maps:to_list(Fields).
attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_schema:field_name(F) end,Fields).
fields()->
    [
     ai_db_schema:def_field(id,integer,[not_null, auto_increment, id]),
     ai_db_schema:def_field(title,string,[not_null]),
     ai_db_schema:def_field(intro,string,[not_null])
    ].
schema()->
  Fields = fields(),
  ai_db_schema:def_schema(topic,Fields).

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
    EncodeTopicIdx = ai_string:to_string(TopicIdx),
    EncodeTopicTitle = ai_url:urlencode(TopicTitle),
    Topic1 = Topic0#{<<"url">> => <<"/topics/",EncodeTopicIdx/binary,"/",EncodeTopicTitle/binary,".html">>},
    if 
      (TopicIdx == Idx) orelse (TopicTitle == Title) ->
          Topic1#{<<"selected">> => true};
      true ->
          Topic1#{<<"selected">> => false}
    end
  end,Topics).