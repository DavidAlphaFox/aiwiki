-module(aiwiki_page_model).
-export([wakeup/1,sleep/1,schema/0,attributes/0]).
-export([build/3,view/1]).
-export([pagination/2,pagination/3]).

-include_lib("stdlib/include/qlc.hrl").

build(Title,Intro,Content)->
  [
   {title,Title},
   {intro,Intro},
   {content,Content},
   {published, false},
   {published_at, calendar:universal_time()},
   {topic_id,0}
  ].
view(Page)->
  lists:foldl(
    fun({Key,Value},Acc) ->
      KeyBin = ai_string:to_string(Key),
      case Key of 
        published_at -> 
          PublishedAt = ai_iso8601:format(Value),
          Acc#{KeyBin => PublishedAt};
        _ -> 
          Acc#{KeyBin => Value}
      end
  end,#{},Page).

pagination(PageIndex,PageCount)->pagination(PageIndex,PageCount,true).
pagination(PageIndex,PageCount,Published)->
  Offset = PageIndex * PageCount,
  F = fun() ->  
      Q = qlc:q([P || P <- mnesia:table(page),
        erlang:element(6,P) == Published]),  
      Q0 = qlc:keysort(7, Q, [{order, descending}]),
      QC = qlc:cursor(Q0),
      Answers = 
        if Offset == 0 -> qlc:next_answers(QC,PageCount);
          true -> 
            qlc:next_answers(QC,Offset),
            qlc:next_answers(QC,PageCount)
        end,
      qlc:delete_cursor(QC),
      Answers
    end,  
  case mnesia:transaction(F) of 
    {atomic,Pages} -> lists:map(fun proplists/1,Pages);
    {aborted,_Reason} -> []
  end.

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

proplists(Record)->
  [_ModelName|Values] = erlang:tuple_to_list(Record),
  Attrs = attributes(),
  lists:zip(Attrs, Values).