-module(db_site).
-export([save/1]).

-include("include/model.hrl").

save(Site)->
  F = fun() -> mnesia:write(Site) end,
  mnesia:transaction(F).
