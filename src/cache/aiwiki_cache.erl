-module(aiwiki_cache).
-export([store/0]).

-define(CACHE_SECTION,<<"cache">>).
-define(POOL_SIZE,<<"pool">>).
-define(HOST,<<"host">>).
-define(PORT,<<"port">>).

store()->
  CacheSection = aiwiki_conf:get_section(?CACHE_SECTION),
  PoolSize =
    case proplists:get_value(?POOL_SIZE,CacheSection) of
      undefined -> 5;
      Size -> Size
    end,
  Hostname = erlang:binary_to_list(proplists:get_value(?HOST, CacheSection)),
  Port = proplists:get_value(?PORT,CacheSection,6379),
  {chalk_cache, #{
                  pool_size => PoolSize,host => Hostname,
                  port => Port
                 }}.
