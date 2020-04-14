-module(db_page).

-export([new/3,new/4]).
-export([select/2,select/3,select/4,count/2]).
-export([fetch/1]).

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

count(_Topic,undefined)->
  Size = mnesia:table_info(page, size),
  {atomic,Size};
count(Topic,Published)->
  MatchSpec =
    if
      Topic == undefined ->
        MatchHead = #page{id = '$1',published = Published,_ = '_'},
        [{MatchHead,[],['$1']}];
      true ->
        MatchHead = #page{id = '$1',published = Published,
                          topic = Topic, _ = '_'},
        [{MatchHead,[],['$1']}]
    end,
  Query =
    fun () ->
        erlang:length(mnesia:select(page, MatchSpec))
    end,
  mnesia:transaction(Query).
fetch(ID)->
  F = fun() ->
          MatchHead = #page{id = '$1',_ = '_' },
          Guard = [{'==', '$1', ID}],
          Result = ['$_'],
          mnesia:select(page, [{MatchHead, Guard, Result}])
      end,  
mnesia:transaction(F).
