-module(aiwiki_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  aiwiki_conf:init(),
  aiwiki_db:create(),
  CacheSpec = aiwiki_cache:store(),
  ai_cache:start_pool(redis,CacheSpec),
  Sup = aiwiki_sup:start_link(),
  aiwiki_server:start(),
  Sup.

stop(_State) ->
  ok.
