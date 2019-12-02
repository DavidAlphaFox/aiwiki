-module(aiwiki_admin_login_controller).
-export([init/2]).
init(#{method := <<"GET">> } = Req,State)->
  {ok,Session0,Req0} = 
    case aiwiki_helper:current_session(Req) of 
      undefined -> aiwiki_helper:new_session(Req);
      Session -> {ok,Session,Req}
    end,

  {CSRFKey,CSRFToken} = aiwiki_helper:csrf(Session0,<<"POST">>,<<"/admin/login.php">>),
  aiwiki_view:render(<<"admin/login">>,Req0,State#{ context => #{
    <<"csrf">> => #{
      <<"param">> => CSRFKey,
      <<"token">> => CSRFToken
    }}
  });
init(#{method := <<"POST">>} = Req,State)->
  Method = cowboy_req:method(Req),
  Path = cowboy_req:path(Req),
  {ok,Body,Req0} = aiwiki_helper:body(Req),
  Session = aiwiki_helper:current_session(Req),
  R = ai_url:parse_query(Body),
  CSRFKey = proplists:get_value(<<"_csrf_param">>,R),
  CSRFToken = proplists:get_value(<<"_csrf_token">>,R),
  case aiwiki_helper:csrf(CSRFToken,CSRFKey,Session,Method,Path) of 
    false -> aiwiki_view:error(400,Req,State);
    true -> aiwiki_view:render(<<"admin/login">>,Req0,State)
  end.