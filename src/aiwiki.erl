-module(aiwiki).
%% API
-export([start/0]).

start() ->
	ok = application:start(crypto),
  ok = application:start(asn1),
  ok = application:start(public_key),
  ok = application:start(ssl),
  ok = application:start(inets),
  ok = application:start(ranch),
  ok = application:start(cowlib),
  ok = application:start(cowboy),
	ok = application:start(jsx),
  ok = application:start(bcrypt),
	ok = application:start(eredis),
  ok = application:start(epgsql),
	ok = application:start(base64url),
  ok = application:start(jwt),
  ok = application:start(ailib),
  ok = application:start(aiconf),
  ok = application:start(aidb),
	ok = application:start(aihtml),
  ok = application:start(aiwiki).

