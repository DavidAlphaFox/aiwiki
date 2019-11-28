-module(aiwiki_conf).
-export([init/0,get_value/2,get_value/3]).
-export([get_section/2,get_section/1,sections/0]).


-define(APP_ENV,"APP_ENV").
-define(DEV_CONF,"etc/dev.json").
-define(PROD_CONF, "etc/prod.json").
%% 默认是配置到sys.config中
get_value(Section,Key)-> ai_conf:value(aiwiki,Section,Key).

get_value(Section,Key,Default)-> ai_conf:value(aiwiki,Section,Key,Default).

get_section(Section)->ai_conf:section(aiwiki,Section).

get_section(Section,Default)-> ai_conf:section(aiwiki,Section,Default).

sections()-> ai_conf:sections(aiwiki).

init() ->
    Conf = get_config_file(),
    ai_conf:load_conf(aiwiki,[Conf]).

get_config_file()->
    {ok, CurrentDirectory} = file:get_cwd(),
    AppEnv =
        case os:getenv(?APP_ENV) of
            false -> prod;
            "dev" -> dev;
            "prod" -> prod
        end,
    if
        AppEnv == dev ->
            filename:join([CurrentDirectory,?DEV_CONF]);
        true ->
            filename:join([CurrentDirectory,?PROD_CONF])
    end.

