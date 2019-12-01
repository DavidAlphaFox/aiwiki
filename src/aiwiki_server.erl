-module(aiwiki_server).
-export([start/0, stop/0]).

-define(SERVER_SECTION,<<"server">>).
-define(PORT,<<"port">>).
register_models() ->
    Models = [
              {page,aiwiki_store,#{module => aiwiki_page_model}}
             ],
    lists:foreach(
      fun({Model,Store,#{module := Module } = Attrs}) ->
          ai_db:register_model(Model,Store,Attrs),
          code:ensure_loaded(Module)
      end,Models).
router_list() ->
    [
     {"/pages/:id/:title/[:format]",aiwiki_page_controller,#{action => show}},
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
    Router =  {'_', RouterList},
    Dispatch = cowboy_router:compile([Router]),
    cowboy:start_clear(aiwiki_server,[{port, Port}],
                      #{env => #{ dispatch => Dispatch }
                      }).


stop() ->
    cowboy:stop_listener(aiwiki_server).
