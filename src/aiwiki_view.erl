-module(aiwiki_view).
-export([render/3,render/4]).
-export([render_json/4,render_json/5,render_api/4]).
-export([error/3,error/4]).
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

reply(Status,Data,Format,Req,State)->
  Req0 = cowboy_req:reply(Status, #{<<"content-type">> => Format}, Data, Req),
  {ok,Req0,State}.

render(Template,Format,Req,State)->
  IsDev = 
    case aiwiki_conf:env() of 
      dev -> true;
      prod -> false
    end,
  Context = maps:get(context,State,#{}),
  Layout = maps:get(layout,State,<<"layout/default">>),
  Body =
    case  Layout of
      null ->
        ai_mustache:render(Template,Context#{<<"is_dev">> => IsDev});
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
  reply(200,Body,Format,Req,State).


render(Template,Req,State)-> render(Template,<<"text/html; charset=utf-8">>,Req,State).

error(StatusCode,Reason,Req,State)->
  IsDev = 
    case aiwiki_conf:env() of 
      dev -> true;
      prod -> false
    end,
  Context = 
    case  Reason of
      undefined ->
       #{
          <<"is_dev">> => IsDev,
          <<"status">> => StatusCode
        };
      _ -> 
        #{
          <<"is_dev">> => IsDev,
          <<"reason">> => Reason,
          <<"status">> => StatusCode
        }  
    end,
  Body = ai_mustache:render(<<"error">>,Context),
  reply(StatusCode,Body,<<"text/html; charset=utf-8">>,Req,State).

error(StatusCode,Req,State)-> error(StatusCode,undefined,Req,State).

redirect(Path,Req,State)->
  Req0 = cowboy_req:reply(302,#{<<"location">> => Path},Req),
  {ok,Req0,State}.


render_json(error,Status,Message,Req,State)->
  Body = jiffy:encode(#{
      <<"message">> => Message
  }),
  reply(Status,Body,<<"application/json; charset=utf-8">>,Req,State);
render_json(data,Status,Data,Req,State)->
  Body = jiffy:encode(Data),
  reply(Status,Body,<<"application/json; charset=utf-8">>,Req,State).
  
render_json(error,Message,Req,State)->
  Body = jiffy:encode(#{
      <<"message">> => Message
  }),
  reply(400,Body,<<"application/json; charset=utf-8">>,Req,State);
render_json(data,Data,Req,State)->
  Body = jiffy:encode(Data),
  reply(200,Body,<<"application/json; charset=utf-8">>,Req,State).


  
render_api({ok,data} ,Data,Req,State)->  {jiffy:encode(Data),Req,State};
render_api({error,data},Message,Req,State)->    
  Data = #{<<"message">> => Message},
  {jiffy:encode(Data),Req,State};
render_api(ok,Data,Req,State)->
  Req0 = cowboy_req:set_resp_body(jiffy:encode(Data),Req),
  {true,Req0,State};
render_api(error,Message,Req,State) ->
  Data = #{<<"message">> => Message},
  Req0 = cowboy_req:set_resp_body(jiffy:encode(Data),Req),
  {false,Req0,State}.

