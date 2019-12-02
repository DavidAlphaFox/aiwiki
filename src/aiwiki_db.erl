-module(aiwiki_db).

-export([run_connection/1, run_transaction/1, store/0]).

-export([create/0]).

-define(DB_SECTION, <<"db">>).

-define(POOL_SIZE, <<"pool">>).

run_connection(Fun) ->
    ai_db_store:dirty(aiwiki_store, Fun).

run_transaction(Fun) ->
    ai_db_store:transaction(aiwiki_store, Fun).

create() ->
    Node = node(),
    _ = application:stop(mnesia),
    _ = case mnesia:create_schema([Node]) of
	  ok -> ok;
	  {error, {Node, {already_exists, Node}}} -> ok
	end,
    {ok, _} = application:ensure_all_started(mnesia),
    mnesia:create_table(page,
			[{attributes, aiwiki_page_model:attributes()},
			 {index, [title]}, {disc_copies, [Node]}]),
    mnesia:create_table(topic,
			[{attributes, aiwiki_topic_model:attributes()},
			 {index, [title]}, {disc_copies, [Node]}]),
    mnesia:create_table(user,
			[{attributes, aiwiki_user_model:attributes()},
			 {disc_copies, [Node]}]),
    mnesia:create_table(site,
			[{attributes, aiwiki_site_model:attributes()},
			 {disc_copies, [Node]}]),
    ok = mnesia:wait_for_tables([page, topic, user, site],
				6000).

store() ->
    DBSection = aiwiki_conf:get_section(?DB_SECTION),
    PoolSize = case proplists:get_value(?POOL_SIZE,
					DBSection)
		   of
		 undefined -> 5;
		 Size -> Size
	       end,
    {aiwiki_store,
     #{pool_size => PoolSize,
       store_handler => ai_db_store_mnesia}}.
