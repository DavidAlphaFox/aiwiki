-module(aiwiki_login_controller).
-behaviour(cowboy_handler).
-export([init/2,terminate/3]).

init(#{method := <<"GET">> } = Req,State)->
  case aiwiki_session_handler:session(Req) of
    undefined ->
      {ok,Session0,Req0} = aiwiki_session_handler:create(Req),
      Actiono(get,Session0,Req0,State);
    {Session,undefined}->
      action(get,Session,Req,State);
    _ ->
      aiwiki_view:redirect(<<"/admin/index.php">>,Req,State)
  end;

init(#{method := <<"POST">>} = Req,State)->
  {ok,Body,Req0} = aiwiki_helper:body(Req),
  R = ai_url:parse_query(Body),
  Session = aiwiki_session_handler:session_id(Req),
  case aiwiki_helper:verify_form(Req,R) of
    false -> aiwiki_view:error(400,Req0,State);
    true -> action(post,Session,Req0,State#{form => R})
  end.

terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.


action(get,Session,Req,State)->
  Path = cowboy_req:path(Req),
  {CSRFKey,CSRFToken} = aiwiki_helper:csrf(Session,<<"POST">>,Path),
  aiwiki_view:render(<<"admin/login">>,Req,State#{ context => #{
    <<"path">> => Path,
    <<"csrf">> => #{
      <<"param">> => CSRFKey,
      <<"token">> => CSRFToken
    }}
  });
action(post,Session,Req,#{form := Form } = State)->
  Email = proplists:get_value(<<"username">>,Form),
  Password = proplists:get_value(<<"password">>,Form),
  case aiwiki_user_model:auth(Email,Password) of
    false ->
      Path = aiwiki_helper:path(Req),
      {CSRFKey,CSRFToken} = aiwiki_helper:csrf(Session,<<"POST">>,Path),
      Context = #{
                  <<"error_message">> => <<"用户名或密码错误"/utf8>>,
                  <<"path">> => Path,
                  <<"csrf">> => #{
                                  <<"param">> => CSRFKey,
                                  <<"token">> => CSRFToken
                                 }
                 },
      aiwiki_view:render(<<"admin/login">>,Req,
                         State#{ context => Context});
    _->
      ok = aiwiki_session_handler:login(Session,Email),
      aiwiki_view:redirect(<<"/admin/index.php">>,Req,State)
  end.
