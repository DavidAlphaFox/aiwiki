-module(aiwiki_server).
-export([start/0, stop/0]).

-define(SERVER_SECTION,<<"server">>).
-define(PORT,<<"port">>).

router_list() ->
    [
     {"/rss.xml",aiwiki_rss_controller,#{layout => null}},
     {"/:title/sitemap.xml",aiwiki_sitemap_controller,#{layout => null}},
     {"/sitemap.xml",aiwiki_sitemap_controller,#{layout => null}},

     {"/topics/:id/:title",aiwiki_topic_controller,#{}},
     {"/api/pages/[:id]",ctrl_page,#{}},

     {"/admin/login.php",aiwiki_login_controller,#{layout => null}},
     {"/admin/page/:action",aiwiki_admin_page_controller,
      #{layout => <<"layout/admin">>}},
     {'_',aiwiki_page_controller,#{action => index}}
    ].

start() ->
  Port = aiwiki_conf:get_value(?SERVER_SECTION,?PORT,5000),
  RouterList = router_list(),
  RouterList0 =
    case aiwiki_conf:env() of
      dev ->
        {ok, CurrentDirectory} = file:get_cwd(),
        StaticFile = filename:join([CurrentDirectory,"public/assets"]),
        BundleFile = filename:join([CurrentDirectory,"public/bundles"]),
        [{"/assets/[...]", cowboy_static, {dir,StaticFile}},
         {"/bundles/[...]", cowboy_static, {dir,BundleFile}}
         |RouterList];
      prod -> RouterList
    end,
  Auth = #{
           exclude => [<<"/admin/login.php">>],
           include => [
                       {<<"/admin/.*">>,aiwiki_session_handler}
                      ],
           to => <<"/admin/login.php">>
          },
  Env = #{
          session => #{},
          render => aiwiki_render,
          auth => Auth
         },
  aicow_server:start(aiwiki_server,Port,RouterList0,Env).


stop() ->
  cowboy:stop_listener(aiwiki_server).
