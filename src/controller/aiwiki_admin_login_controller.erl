-module(aiwiki_admin_login_controller).
-export([init/2]).
init(#{method := <<"GET">> } = Req,State)->
  {ok,Session0,Req0} = 
    case aiwiki_helper:current_session(Req) of 
      undefined -> aiwiki_helper:new_session(Req);
      Session -> {ok,Session,Req}
    end,
  Path = cowboy_req:path(Req),
  {CSRFKey,CSRFToken} = aiwiki_helper:csrf(Session0,<<"POST">>,Path),
  aiwiki_view:render(<<"admin/login">>,Req0,State#{ context => #{
    <<"path">> => Path,
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
  Email = proplists:get_value(<<"username">>,R),
  Password = proplists:get_value(<<"password">>,R),
  case aiwiki_helper:csrf(CSRFToken,CSRFKey,Session,Method,Path) of 
    false -> aiwiki_view:error(400,Req,State);
    true -> 
      case aiwiki_user_model:auth(Email,Password) of 
        false -> aiwiki_view:render(<<"admin/login">>,Req0,State#{
          context => #{
            <<"error_message">> => <<"用户名或密码错误"/utf8>>,
            <<"path">> => Path,
            <<"csrf">> => #{
                <<"param">> => CSRFKey,
                <<"token">> => CSRFToken
            }
          }
        });
        _ -> aiwiki_view:redirect(<<"/admin/index.php">>,Req,State)
      end
  end.
