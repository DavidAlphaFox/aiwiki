-module(aiwiki_server).
-export([start/0, stop/0]).

-define(SERVER_SECTION,<<"server">>).
-define(PORT,<<"port">>).
register_models() ->
    Models = [
              {page,aiwiki_store,#{module => aiwiki_page_model}},
              {topic,aiwiki_store,#{module => aiwiki_topic_model}},
              {site,aiwiki_store,#{module => aiwiki_site_model}}
             ],
    lists:foreach(
      fun({Model,Store,#{module := Module } = Attrs}) ->
          ai_db:register_model(Model,Store,Attrs),
          code:ensure_loaded(Module)
      end,Models).
router_list() ->
    [
     {"/rss.xml",aiwiki_rss_controller,#{layout => null}},
     {"/topics/:id/:title",aiwiki_topic_controller,#{}},
     {"/pages/:id/:title",aiwiki_page_controller,#{action => show}},
     {"/admin/login.php",aiwiki_admin_login_controller,#{layout => <<"layout/admin">>}},
     {"/admin/index.php",aiwiki_admin_index_controller,#{layout => <<"layout/admin">>}},
     {"/admin/pages.php",aiwiki_admin_page_controller,#{layout => <<"layout/admin">>}},
     {"/api/pages/show.json",aiwiki_api_page_controller,#{}},
     {"/admin/pages/edit.php",aiwiki_admin_page_controller,#{
       layout => <<"layout/admin">>,
        action => edit
      }},
     {"/admin/pages/create.php",aiwiki_admin_page_controller,#{
       layout => <<"layout/admin">>,
       action => create
      }},
     {'_',aiwiki_page_controller,#{action => index}}
    ].

start() ->
    register_models(),
    ai_mustache:bootstrap(),
    Port = aiwiki_conf:get_value(?SERVER_SECTION,?PORT,5000),
    RouterList = router_list(),
    lists:foreach(
      fun({_Path,Module,_Ctx})->
          {module,Module} = code:ensure_loaded(Module)
      end,RouterList),
    RouterList0 = 
        case aiwiki_conf:env() of 
          dev ->
            {ok, CurrentDirectory} = file:get_cwd(),
            StaticFile = filename:join([CurrentDirectory,"public/assets"]),
            [{"/assets/[...]", cowboy_static, {dir,StaticFile}}|RouterList];
          prod -> RouterList
        end,
    Router =  {'_', RouterList0},
    Auth = #{
        exclude => [<<"/admin/login.php">>],
        include => [<<"/admin.*">>],
        to => <<"/admin/login.php">>
    },
    Dispatch = cowboy_router:compile([Router]),
    cowboy:start_clear(aiwiki_server,[{port, Port}],
                      #{
                        env => #{ dispatch => Dispatch, auth => Auth },
                        middlewares => [cowboy_router,aiwiki_auth_handler,cowboy_handler]
                      }).


stop() ->
    cowboy:stop_listener(aiwiki_server).
