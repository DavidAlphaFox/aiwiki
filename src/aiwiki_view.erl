-module(aiwiki_view).
-export([render/3,render/4,error/3]).
-export([redirect/3]).

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
site_intro(Acc,Context)->
  case maps:get(<<"intro">>,Context,undefined) of 
    undefined -> Acc;
    Intro ->
      case erlang:byte_size(Acc) of 
        0 -> Intro;
        _ -> <<Intro/binary,",",Acc/binary>>
      end
  end.
site_keywords(Acc,Context)->
  case maps:get(<<"keywords">>,Context,undefined) of 
    undefined -> Acc;
    Keywords ->
      case erlang:byte_size(Acc) of 
        0 -> Keywords;
        _ -> <<Keywords/binary,",",Acc/binary>>
      end
  end.
render(Template,Format,Req,State)->
  IsDev = 
    case aiwiki_conf:env() of 
      dev -> true;
      prod -> false
    end,
  Context = maps:get(context,State,#{}),
  Layout = maps:get(layout,State,<<"layout/default">>),
  Req0 =
    case  Layout of
      null ->
        Body = ai_mustache:render(Template,Context#{<<"is_dev">> => IsDev}),
        cowboy_req:reply(200, #{<<"content-type">> => Format}, Body, Req);
      _ ->
        Site = ai_db:find_all(site),
        Site0 = lists:foldl(
            fun(Conf,Acc) ->
              Key = proplists:get_value(key,Conf),
              Value = proplists:get_value(value,Conf),
              Acc#{Key => Value}
            end,#{},Site),
        LayoutContext = Context#{
            <<"yield">> => [fun yield/2,Template],
            <<"site_title">> => fun site_title/2,
            <<"site_intro">> => fun site_intro/2,
            <<"site_keywords">> => fun site_keywords/2,
            <<"site">> => Site0,
            <<"is_dev">> => IsDev
        },

        Body = ai_mustache:render(Layout,LayoutContext),
        cowboy_req:reply(200, #{<<"content-type">> => Format}, Body, Req)
  end,
  {ok,Req0,State}.

render(Template,Req,State)->
  render(Template,<<"text/html; charset=utf-8">>,Req,State).

error(StatusCode,Req,State)->
  Body = ai_mustache:render(<<"error">>,#{
    <<"status">> => StatusCode
  }),
  Req0 = cowboy_req:reply(StatusCode, 
    #{<<"content-type">> => <<"text/html; charset=utf-8">>}, 
    Body, Req),
  {ok,Req0,State}.

redirect(Path,Req,State)->
  Req0 = cowboy_req:reply(302,
    #{<<"location">> => Path},Req),
  {ok,Req0,State}.