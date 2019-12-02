-module(aiwiki_site_model).
-export([sleep/1,wakeup/1,schema/0,attributes/0]).


sleep(PropList)-> maps:from_list(PropList).
wakeup(Fields)-> maps:to_list(Fields).
attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_schema:field_name(F) end,Fields).
fields()->
    [
     ai_db_schema:def_field(key,string,[not_null,id]),
     ai_db_schema:def_field(value,string,[not_null])
    ].
schema()->
  Fields = fields(),
  ai_db_schema:def_schema(topic,Fields).
