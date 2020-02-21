-module(aiwiki_db).

-export([create/0]).

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
    mnesia:create_table(exlink,
                        [{attributes, aiwiki_site_model:attributes()},
                         {disc_copies, [Node]}]),
    ok = mnesia:wait_for_tables([page, topic,user, site,exlink]
                               ,6000).
