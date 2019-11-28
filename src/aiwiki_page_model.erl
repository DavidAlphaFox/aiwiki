-module(aiwiki_page_model).
-export([schema/0]).
-export([wakeup/1,sleep/1]).


sleep(PropList)-> maps:from_list(PropList).

wakeup(Fields)->
    Lists = maps:to_list(Fields),
    SchemaFields = schema_fields(),
    lists:map(fun({K,V} = I)->
                      SF  = proplists:get_value(K,SchemaFields,[]),
                      case lists:keyfind(as,1,SF) of
                          false -> I;
                          {as,TK} -> {TK,V}
                      end
              end,Lists).
fields()->
    [
     ai_db_schema:def_field(id,integer,[not_null, auto_increment, id]),
     ai_db_schema:def_field(title,string,[not_null]),
     ai_db_schema:def_field(intro,string,[not_null]),
     ai_db_schema:def_field(published,boolean,[]),
     ai_db_schema:def_field(published_at,datetime,[{as,publishedAt}]),
     ai_db_schema:def_field(topic_id,integer,[{as,topicID}])
    ].
schema_fields()->
    lists:map(
      fun(F) ->
              {ai_db_schema:field_name(F),
               ai_db_schema:field_attrs(F)}
      end,fields()).

schema()->
    Fields = fields(),
    ai_db_schema:def_schema(pages,Fields).

