-module(srv_site).
-include("include/model.hrl").

-export([fetch/1]).
-export([load/2]).

fetch(site)-> to_map([brand,footer,keywords,intro,scripts]);
fetch(header) -> to_map([header]);
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

load(Filename,Key)->
  {ok,Binary} = file:read_file(Filename),
  mnesia:transaction(
    fun()->
        Site = #site{key = Key,value = Binary},
        mnesia:write(Site)
    end).
