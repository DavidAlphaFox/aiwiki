-module(aiwiki_view).
-export([render/3]).

yield(Template,Context)->
  ai_mustache:render(Template,Context).

site_title(Acc,Context)->
  case  maps:get(<<"title">>,Context,undefined) of
    undefined -> Acc;
    Title ->
      case erlang:byte_size(Acc) of
        0 -> Title;
        _ -> <<Title/binary,"-",Acc/binary>>
      end
  end.

render(Template,Req,State)->
  Context = maps:get(context,State,#{}),
  LayoutContext = Context#{
                            <<"yield">> => [fun yield/2,Template],
                            <<"site_title">> => fun site_title/2
                          },
  Body = ai_mustache:render(<<"layout/default">>,LayoutContext),
  Req0 = cowboy_req:reply(200, #{
		<<"content-type">> => <<"text/html; charset=utf-8">>
	}, Body, Req),
  {ok,Req0,State}.
