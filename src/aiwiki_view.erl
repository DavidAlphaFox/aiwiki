-module(aiwiki_view).
-export([render/3,render/4]).

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

render(Template,Format,Req,State)->
  Context = maps:get(context,State,#{}),
  Layout = maps:get(layout,State,<<"layout/default">>),
  Req0 =
    case  Layout of
      null ->
        Body = ai_mustache:render(Template,Context),
        cowboy_req:reply(200, #{<<"content-type">> => Format}, Body, Req);
      _ ->
        LayoutContext = Context#{
            <<"yield">> => [fun yield/2,Template],
            <<"site_title">> => fun site_title/2
        },
        Body = ai_mustache:render(Layout,LayoutContext),
        cowboy_req:reply(200, #{<<"content-type">> => Format}, Body, Req)
  end,
  {ok,Req0,State}.

render(Template,Req,State)->
  render(Template,<<"text/html; charset=utf-8">>,Req,State).
 