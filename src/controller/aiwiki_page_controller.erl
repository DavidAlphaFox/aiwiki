-module(aiwiki_page_controller).
-export([init/2,terminate/3]).

-include_lib("ailib/include/ai_url.hrl").

init(Req,#{action := index} = State)->
    QS = cowboy_req:parse_qs(Req),
    {PageIndex,PageCount} = aiwiki_pager_helper:index_and_count(QS),
    Pages = aiwik_page_service:pages(PageIndex,PageCount),
    Topics = aiwiki_topic_helper:aside(undefined,undefined),
    Exlinks = exlink(),
    Pager = aiwiki_page_service:pagination(PageIndex,PageCount,erlang:length(Pages)),
    Context = #{
                <<"pages">> => Pages,
                <<"topics">> => Topics,
                <<"pager">> => Pager,
                <<"exlinks">> => Exlinks
               },
    {ok,<<"page/index">>,Req,State#{context => Context}};
 
init(Req,#{action := show} = State)->
    PageID = cowboy_req:binding(id,Req),
    Title = cowboy_req:binding(title,Req),
    {Title1,_} = aiwiki_helper:resource_and_format(Title),
    Title2 = ai_url:urldecode(Title1),
    PageID0 = ai_string:to_integer(PageID),
    [Page] = ai_db:find_by(page,[{'or',[{id,PageID0},{title,Title2}]}]),
    Page0 = aiwiki_page_helper:view_model(Page),
    Title2 = proplists:get_value(title,Page),
  aiwiki_view:render(<<"page/show">>,Req,State#{context => #{
      <<"title">> => Title2,
      <<"page">> => Page0
    }}).


terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.

exlink()->
  Exlinks = ai_db:find_all(exlink),
  Site = aiwiki_helper:site(),
  Query =
    lists:filter(fun({K,_V})->
                     K =:= <<"utm_source">>
                       orelse K =:= <<"utm_medium">>
                       orelse K =:= <<"utm_campaign">>
                 end,maps:to_list(Site)),
    lists:map(fun(Link) ->
                  Title = proplists:get_value(key,Link),
                  Url0 = proplists:get_value(value,Link),
                  Url1 = ai_url:parse(Url0),
                  QS = Url1#ai_url.qs,
                  QS1 = case QS of
                          undefined -> Query;
                          _ -> QS ++ Query
                        end,
                  Url2 = Url1#ai_url{qs = QS1},
                  #{
                    <<"title">> => Title,
                    <<"url">> => ai_url:build(Url2)
                   }
              end,Exlinks).
