-module(db_topic).
-export([new/2]).
-export([
         select/0,
         save/1
        ]).
-include("include/model.hrl").

new(Title,Intro)->
  #topic{
     id = aiwiki_db:id(),
     title = Title,
     intro = Intro
    }.

select()->
  MatchHead = #topic{ _='_'},
  Query = fun () -> mnesia:select(topic,[{MatchHead, [], ['$_']}]) end,
  mnesia:transaction(Query).

save(Topic)->
  F = fun() -> mnesia:write(Topic) end,
  mnesia:transaction(F).
