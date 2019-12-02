-module(aiwiki_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
		application:start(crypto),
    application:start(asn1),
    application:start(public_key),
    application:start(ssl),
    application:start(inets),
    application:start(ranch),
    application:start(cowlib),
    application:start(cowboy),
	  application:start(jsx),
    application:start(bcrypt),
    application:start(eredis),
    application:start(epgsql),
	  application:start(base64url),
    application:start(jwt),
    application:start(ailib),
    application:start(aiconf),
    application:start(aidb),
    application:start(aihtml),
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
