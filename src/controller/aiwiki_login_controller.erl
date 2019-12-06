-module(aiwiki_login_controller).
-behaviour(cowboy_handler).
-export([init/2,terminate/3]).
init(#{method := <<"GET">> } = Req,State)->
  {ok,Session0,Req0} = 
    case aiwiki_session_handler:session_id(Req) of
      undefined -> aiwiki_session_handler:create(Req);
      Session -> {ok,Session,Req}
    end,
  Path = cowboy_req:path(Req),
  {CSRFKey,CSRFToken} = aiwiki_helper:csrf(Session0,<<"POST">>,Path),
  aiwiki_view:render(<<"login">>,Req0,State#{ context => #{
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
  Session = aiwiki_session_handler:session_id(Req),
  R = ai_url:parse_query(Body),
  CSRFKey = proplists:get_value(<<"_csrf_param">>,R),
  CSRFToken = proplists:get_value(<<"_csrf_token">>,R),
  Email = proplists:get_value(<<"username">>,R),
  Password = proplists:get_value(<<"password">>,R),
  case aiwiki_helper:csrf(CSRFToken,CSRFKey,Session,Method,Path) of 
    false -> aiwiki_view:error(400,Req,State);
    true -> 
      case aiwiki_user_model:auth(Email,Password) of 
        false -> aiwiki_view:render(<<"login">>,Req0,State#{
          context => #{
            <<"error_message">> => <<"用户名或密码错误"/utf8>>,
            <<"path">> => Path,
            <<"csrf">> => #{
                <<"param">> => CSRFKey,
                <<"token">> => CSRFToken
            }
          }
        });
        _->
          ok = aiwiki_session_handler:login(Session,Email),
          aiwiki_view:redirect(<<"/admin/">>,Req,State)
      end
  end.
terminate(normal,_Req,_State) -> ok;
terminate(Reason,Req,State)->
  Reason0 = io_lib:format("~p~n",[Reason]),
  aiwiki_view:error(500,Reason0,Req,State),
  ok.
