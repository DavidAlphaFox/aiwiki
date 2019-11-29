-module(aiwiki_page_model).
-export([wakeup/1,sleep/1,schema/0,attributes/0]).
-export([build/3]).

build(Title,Intro,Content)->
  [
   {title,Title},
   {intro,Intro},
   {content,Content},
   {published, false},
   {published_at, calendar:universal_time()},
   {topic_id,0}
  ].

sleep(PropList)-> maps:from_list(PropList).

wakeup(Fields)-> maps:to_list(Fields).
attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_schema:field_name(F) end,Fields).
fields()->
    [
     ai_db_schema:def_field(id,integer,[not_null, auto_increment, id]),
     ai_db_schema:def_field(title,string,[not_null]),
     ai_db_schema:def_field(intro,string,[not_null]),
     ai_db_schema:def_field(content,staring,[not_null]),
     ai_db_schema:def_field(published,boolean,[]),
     ai_db_schema:def_field(published_at,datetime,[]),
     ai_db_schema:def_field(topic_id,integer,[])
    ].

schema()->
    Fields = fields(),
    ai_db_schema:def_schema(page,Fields).

