-module(aiwiki_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    aiwiki_conf:init(),
    aiwiki_db:create(),
    StoreSpec = aiwiki_db:store(),
    ai_db:start_pool(store,StoreSpec),
    CacheSpec = aiwiki_db:cache(),
    ai_db:start_pool(redis,CacheSpec),
  	Sup = aiwiki_sup:start_link(),
    aiwiki_server:start(),
    Sup.

stop(_State) ->
	ok.
