-module(db_site).
-export([
         save/1,
         fetch/1,
         to_json/1
        ]).

-include_lib("stdlib/include/qlc.hrl").
-include("include/model.hrl").

save(Site)->
  F = fun() -> mnesia:write(Site) end,
  mnesia:transaction(F).

fetch(links)->
  F = fun() ->
          MatchHead = #site{key = <<"exlinks">>, _ = '_'},
          case mnesia:select(site,[{MatchHead,[],['$_']}]) of
            [] -> [#site{key = <<"exlinks">>, value = #{}}];
            Records -> Records
          end
      end,
  mnesia:transaction(F);
fetch(Key) when erlang:is_atom(Key)->
  KeyBin = ai_string:to_string(Key),
  F = fun() ->
          MatchHead = #site{key = KeyBin, _ = '_'},
          mnesia:select(site,[{MatchHead,[],['$_']}])
      end,
  mnesia:transaction(F);
fetch(Keys) ->
  Keys0 = lists:map(fun ai_string:to_string/1,Keys),
  Query =
    fun() ->
        Q = qlc:q([E || E <- mnesia:table(site),
                        lists:member(E#site.key,Keys0)]),
        qlc:e(Q)
    end,
  mnesia:transaction(Query).

to_json(Item)->
  #{
    Item#site.key => Item#site.value
   }.
