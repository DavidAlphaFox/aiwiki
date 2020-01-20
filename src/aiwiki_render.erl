-module(aiwiki_render).
-behavior(aicow_render).

-export([render/4,render/5,
         render_exception/4]).
-export([redirect/3]).

redirect(Path,Req,State)->
  Req0 = cowboy_req:reply(302,#{<<"location">> => Path},Req),
  {ok,Req0,State}.


render(Handler,Template,Req,State) ->
    render(Handler,Template,<<"text/html; charset=utf-8">>,Req,State).
render(_Handler,Template,ContentType,Req,State)->
  IsDev =
    case aiwiki_conf:env() of
      dev -> true;
      prod -> false
    end,
  Context = maps:get(context,State,#{}),
  Layout = maps:get(layout,State,<<"layout/default">>),
  Body =
    case  Layout of
      null -> ai_mustache:render(Template,Context#{<<"is_dev">> => IsDev});
      _ ->
        Site = aiwiki_helper:site(),
        LayoutContext = Context#{
                                 <<"yield">> => [fun yield/2,Template],
                                 <<"site_title">> => fun site_title/2,
                                 <<"site_intro">> => fun site_intro/2,
                                 <<"site_keywords">> => fun site_keywords/2,
                                 <<"site">> => Site,
                                 <<"is_dev">> => IsDev
                                },
        ai_mustache:render(Layout,LayoutContext)
        end,
    reply(200,Body,ContentType,Req).

render_exception(_Handler,Reason,Req,_State) ->
  IsDev =
    case aiwiki_conf:env() of
      dev -> true;
      prod -> false
    end,
  Context =
    case  Reason of
      undefined ->
       #{ <<"is_dev">> => IsDev };
        _ ->
            Reason0 = io_lib:format("~p~n",[Reason]), 
            #{
              <<"is_dev">> => IsDev,
              <<"reason">> => Reason0
             }
    end,
    Body = ai_mustache:render(<<"error">>,Context),
    reply(500,Body,<<"text/html; charset=utf-8">>,Req).



reply(Status,Data,Format,Req)->
    cowboy_req:reply(Status, #{<<"content-type">> => Format}, Data, Req).


yield(Template,Context)-> ai_mustache:render(Template,Context).

site_title(Acc,Context)->
  case  ai_maps:get([<<"site">>,<<"title">>],Context,undefined) of
    undefined -> Acc;
    Title ->
      case erlang:byte_size(Acc) of
        0 -> Title;
        _ -> <<Title/binary,"-",Acc/binary>>
      end
  end.
site_intro(Acc,Context)->
  case ai_maps:get([<<"site">>,<<"intro">>],Context,undefined) of
    undefined -> Acc;
    Intro ->
      case erlang:byte_size(Acc) of
        0 -> Intro;
        _ -> <<Intro/binary,",",Acc/binary>>
      end
  end.
site_keywords(Acc,Context)->
  case ai_maps:get([<<"site">>,<<"keywords">>],Context,undefined) of
    undefined -> Acc;
    Keywords ->
      case erlang:byte_size(Acc) of
        0 -> Keywords;
        _ -> <<Keywords/binary,",",Acc/binary>>
      end
  end.
