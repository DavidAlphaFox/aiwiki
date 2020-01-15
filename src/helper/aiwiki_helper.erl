-module(aiwiki_helper).
-export([view_model/1]).
-export([site/0]).

site()->
  Site = ai_db:find_all(site),
  lists:foldl(
    fun(Conf,Acc) ->
        Key = proplists:get_value(key,Conf),
        Value = proplists:get_value(value,Conf),
        Acc#{Key => Value}
    end,#{},Site).

view_model(Model)->
  lists:foldl(
    fun({Key,Value},Acc) ->
      Acc#{ai_string:to_string(Key) => Value}
    end,#{},Model).

