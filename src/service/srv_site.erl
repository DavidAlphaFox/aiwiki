-module(srv_site).
-include("include/model.hrl").

-export([fetch/1]).

fetch(site)-> to_map([brand,footer]);
fetch(header) -> to_map([header,keywords,intro]);
fetch(rss) -> to_map([host,brand,intro]);
fetch(sitemap) -> to_map([host]).


to_map(Keys)->
  case db_site:fetch(Keys) of
    {atomic,Sites} ->
      lists:foldl(
        fun(I,Acc) ->
            Key = erlang:binary_to_existing_atom(I#site.key, utf8),
            Acc#{Key => I#site.value}
        end, #{},Sites);
    _ -> #{}
  end.
