-module(db_page).

-export([new/3,new/4,to_json/1]).
-export([
         select/2,
         select/3,
         select/4,
         count/2,
         fetch/1,
         save/1
        ]).


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
to_json(Item)->
  M = #{
        id => Item#page.id,
        title => Item#page.title,
        intro => Item#page.intro,
        content => Item#page.content,
        published => Item#page.published,
        topic => Item#page.topic
       },
  if
    Item#page.published_at == undefined -> M;
    true ->
      M#{
         publishedAt => ai_iso8601:format(Item#page.published_at)
        }
  end.

select(PageIndex,PageCount)->select(PageIndex,PageCount, undefined,true).
select(PageIndex,PageCount,Topic)->select(PageIndex,PageCount, Topic,true).
select(PageIndex,PageCount,Topic,Published)->
  Offset = PageIndex * PageCount,
  Order = fun(A,B)-> A#page.published_at > B#page.published_at end,
  Query =
    fun() ->
        Q = case {Topic,Published} of
              {undefined,undefined} ->
                qlc:q([E|| E <- mnesia:table(page)]);
              {undefined,_}->
                qlc:q([E || E <- mnesia:table(page), E#page.published == Published]);
              _->
                qlc:q([E || E <- mnesia:table(page),
                            E#page.published == Published,
                            E#page.topic == Topic
                      ])
              end,
        Q0 = qlc:sort(Q,[{order,Order}]),
        QC = qlc:cursor(Q0),
        Answers =
          if
            Offset == 0 -> qlc:next_answers(QC,PageCount);
            true ->
              qlc:next_answers(QC,Offset),
              qlc:next_answers(QC,PageCount)
          end,
        qlc:delete_cursor(QC),
        Answers
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

save(Page)->
  F = fun() -> mnesia:write(Page) end,
  mnesia:transaction(F).
