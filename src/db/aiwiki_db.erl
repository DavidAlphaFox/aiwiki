-module(aiwiki_db).

-export([create/0,id/0]).

-include("include/model.hrl").

create() ->
  Node = node(),
  _ = application:stop(mnesia),
  _ = case mnesia:create_schema([Node]) of
        ok -> ok;
        {error, {Node, {already_exists, Node}}} -> ok
      end,
  {ok, _} = application:ensure_all_started(mnesia),
  mnesia:create_table(page,
                      [
                       {attributes, record_info(fields,page)},
                       {index, [title]},
                       {disc_copies, [Node]}
                      ]),
  mnesia:create_table(topic,
                        [{attributes,record_info(fields,topic)},
                         {index, [title]}, {disc_copies, [Node]}]),
   
  mnesia:create_table(site,
                      [{attributes, record_info(fields,site)},
                       {disc_copies, [Node]}]),
  ok = mnesia:wait_for_tables([page,topic,site],6000).

id()-> id(ai_id:next_id()).
id({fail,_}) -> id();
id({ok,ID}) -> ID.
