-module(aiwiki_topic_model).
-export([sleep/1,wakeup/1,schema/0,attributes/0]).


sleep(PropList)-> maps:from_list(PropList).
wakeup(Fields)-> maps:to_list(Fields).
attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_field:name(F) end,Fields).
fields()->
    [
     ai_db_field:define(id,integer,[not_null, auto_increment, id]),
     ai_db_field:define(title,string,[not_null]),
     ai_db_field:define(intro,string,[not_null])
    ].
schema()->
  Fields = fields(),
  ai_db_schema:define(topic,Fields).
