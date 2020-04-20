-module(db_site).
-export([
         save/1,
         fetch/1,
         to_json/1
        ]).

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
fetch(footer) ->
  F = fun() ->
          MatchHead = #site{key = <<"footer">>, _ = '_'},
          mnesia:select(site,[{MatchHead,[],['$_']}])
      end,
  mnesia:transaction(F);
fetch(brand)->
  F = fun() ->
          MatchHead = #site{key = <<"brand">>, _ = '_'},
          mnesia:select(site,[{MatchHead,[],['$_']}])
      end,
  mnesia:transaction(F).
to_json(Item)->
  #{
    Item#site.key => Item#site.value
   }.
