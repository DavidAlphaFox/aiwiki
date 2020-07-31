-module(aiwiki_server).
-export([start/0, stop/0]).

-define(SERVER_SECTION,<<"server">>).
-define(PORT,<<"port">>).

router_list() ->
    [
     {"/rss.xml",ctrl_rss,#{}},
     {"/:title/sitemap.xml",ctrl_sitemap,#{layout => null}},
     {"/sitemap.xml",ctrl_sitemap,#{layout => null}},
     {"/api/pages/[:id]",ctrl_page,#{}},
     {"/api/sites/[:id]",ctrl_site,#{}},
     {"/api/topics",ctrl_topic,#{}},
     {"/api/auth",ctrl_auth,#{}}
    ].

start() ->
  Port = aiwiki_conf:get_value(?SERVER_SECTION,?PORT,5000),
  Router = aicow_server:router(router_list()),
  cowboy:start_clear(aiwiki_server,[{port, Port}],
                     #{env => #{dispatch => Router}}).
stop() ->
  cowboy:stop_listener(aiwiki_server).
