-module(db_page).

-export([new/3,new/4]).
-export([select/2,select/3,select/4]).

-include_lib("stdlib/include/qlc.hrl").
-include("include/model.hrl").

new(Title,Intro,Content) -> new(Title,Intro,Content,undefined).

new(Title,Intro,Content,Topic)->
  #page{
     id = aiwiki_db:id(),
     title = Title,
     intro = Intro,
     content = Content,
     published = false,
     topic = Topic
    }.

select(PageIndex,PageCount)->select(PageIndex,PageCount, undefined,true).
select(PageIndex,PageCount,Topic)->select(PageIndex,PageCount, Topic,true).
select(PageIndex,PageCount,Topic,Published)->
  Offset = PageIndex * PageCount,
  MatchHead =
    case {Topic,Published} of
      {undefined,undefined}-> #page{_ = '_'};
      {undefined,_} -> #page{_ = '_',published = Published};
      _ -> #page{ _ = '_',published = Published, topic = Topic}
    end,
  MatchSpec = [{MatchHead,[],['$_']}],
  Query =
    case PageCount of
      0 -> fun () ->  mnesia:select(page, MatchSpec) end;
      _ ->
        fun () ->
            case mnesia:select(page, MatchSpec, Offset + PageCount, read) of
              {ManyItems, _Cont} when length(ManyItems) >= Offset ->
                lists:sublist(ManyItems, Offset + 1, PageCount);
              {_ManyItems, _Cont} -> [];
              '$end_of_table' -> []
            end
        end
    end,
  mnesia:transaction(Query).
