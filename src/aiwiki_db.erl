-module(aiwiki_db).
-export([store/0,run_connection/1,run_transaction/1]).

-define(DB_SECTION,<<"db">>).
-define(CACHE_SECTION,<<"cache">>).
-define(POOL_SIZE,<<"pool">>).
-define(HOST,<<"host">>).
-define(USERNAME,<<"username">>).
-define(PASSWORD,<<"password">>).
-define(DATABASE,<<"database">>).
-define(PORT,<<"port">>).


run_connection(Fun)-> ai_db_store:dirty(aiwiki_store,Fun).
run_transaction(Fun)-> ai_db_store:transaction(aiwiki_store,Fun).

store()->
    DBSection = aiwiki_conf:get_section(?DB_SECTION),
    PoolSize =
        case proplists:get_value(?POOL_SIZE,DBSection) of
            undefined -> 5;
            Size -> Size
        end,
    Hostname = erlang:binary_to_list(proplists:get_value(?HOST, DBSection)),
    Username = proplists:get_value(?USERNAME, DBSection),
    Password = proplists:get_value(?PASSWORD, DBSection),
    Database = proplists:get_value(?DATABASE,DBSection),
    Port = proplists:get_value(?PORT,DBSection,5432),
    {aiwiki_store, #{
                    pool_size => PoolSize,host => Hostname,
                    port => Port, username => Username,
                    password => Password, database => Database,
                    store_handler => ai_db_store_postgres
     }}.
