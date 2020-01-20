-module(aiwiki_page_model).
-export([schema/0,attributes/0]).
-export([build/3]).
-export([pagination/2,pagination/3,pagination/4]).

-include_lib("stdlib/include/qlc.hrl").

build(Title,Intro,Content)->
  #{
    title => Title,
    intro => Intro,
    content => Content,
    published => false,
    topic_id => 0
   }.
  
pagination(PageIndex,PageCount)->pagination(PageIndex,PageCount, undefined,true).
pagination(PageIndex,PageCount,TopicID)->pagination(PageIndex,PageCount, TopicID,true).
pagination(PageIndex,PageCount,TopicID,Published)->
  Offset = PageIndex * PageCount,
  Cond =
    case {TopicID,Published} of
      {undefined,undefined} -> [];
      {undefined,_}-> [{published,Published}];
      _ -> [{'and',[
                    {published,Published},
                    {topic_id,TopicID}
                   ]}]
    end,
  ai_db:find_by(page,Cond,PageCount,Offset).


attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_field:name(F) end,Fields).

fields()->
    [
     ai_db_field:define(id,integer,[not_null, auto_increment, id]),
     ai_db_field:define(title,string,[not_null]),
     ai_db_field:define(intro,string,[not_null]),
     ai_db_field:define(content,staring,[not_null]),
     ai_db_field:define(published,boolean,[]),
     ai_db_field:define(published_at,datetime,[]),
     ai_db_field:define(topic_id,integer,[])
    ].

schema()->
    Fields = fields(),
    ai_db_schema:define(page,Fields).
