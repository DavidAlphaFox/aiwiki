-module(srv_site).
-include("include/model.hrl").

-export([fetch/1]).

fetch(site)->
  case db_site:fetch([brand,footer]) of
    {atomic,[Site]} -> to_map(Site);
    _ -> #{}
  end;
fetch(header) ->
  case db_site:fetch([header,keywords,intro]) of
    {atomic,[Site]} -> to_map(Site);
    _ -> #{}
  end.
to_map(Site)->
  lists:foldl(
    fun(I,Acc) ->
        Key = erlang:binary_to_existing_atom(I#site.key, utf8),
        Acc#{Key => I#site.value}
    end, #{},Site).
