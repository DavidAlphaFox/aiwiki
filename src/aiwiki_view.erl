-module(aiwiki_view).
-export([render/3]).

yield(<<>>,Context)->
  YieldTemplate = maps:get(<<"yield_template">>,Context),
  ai_mustache:render(YieldTemplate,Context);
yield(Template,Context)->
  ai_mustache:render(Template,Context).

site_title(Acc,Context)->
  case  maps:get(<<"title">>,Context,undefined) of
    undefined -> Acc;
    Title ->
      io:format("Brand:~p~n",[Acc]),
      case erlang:byte_size(Acc) of
        0 -> Title;
        _ -> <<Title/binary,"-",Acc/binary>>
      end
  end.

render(Template,Req,State)->
  Context = maps:get(context,State,#{}),
  LayoutContext = Context#{
                            <<"yield">> => fun yield/2,
                            <<"site_title">> => fun site_title/2,
                            <<"yield_template">> => Template
                          },
  Body = ai_mustache:render(<<"_layout/default">>,LayoutContext),
  Req0 = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/html; charset=utf-8">>
	}, Body, Req),
  {ok,Req0,State}.
