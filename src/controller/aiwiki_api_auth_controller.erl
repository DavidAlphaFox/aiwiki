-module(aiwiki_api_auth_controller).
-behaviour(cowboy_handler).
-export([init/2]).
init(Req,State)->
    case aiwiki_session_handler:session(Req) of
        {_Session,Claims} ->
            {ok,Token } =
                aiwiki_token_handler:create(Claims),
            aiwiki_view:render_json(data,[{token,Token}],Req,State);
        _ ->
            aiwiki_view:render_json(error,<<"Could not find the session">>,Req,State)
    end.

%terminate(normal,_Req,_State) -> ok;
%terminate(Reason,Req,State)->
%  Reason0 = ai_string:to_string(io_lib:format("~p~n",[Reason])),
%  aiwiki_view:render_json(error,500,Reason0,Req,State),
%  ok.
