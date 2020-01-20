-module(aiwiki_helper).
-export([view_model/1]).
-export([site/0]).

site()->
  Site = ai_db:find_all(site),
  lists:foldl(
    fun(Conf,Acc) ->
        Fields = ai_db_model:fields(Conf),
        maps:merge(Acc,Fields)
    end,#{},Site).

view_model(Model)->
  maps:fold(
    fun(Key,Value,Acc) ->
        Acc#{ai_string:to_string(Key) => Value}
    end,#{},Model).

