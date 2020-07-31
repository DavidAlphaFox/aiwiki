-module(ctrl_auth).
-export([init/2]).
-export([content_types_accepted/2,
         content_types_provided/2,
         allow_missing_post/2,
         resource_exists/2,
         allowed_methods/2,
         malformed_request/2,
         forbidden/2,
         options/2]).
-export([handle_action/2]).


init(Req, State) -> {cowboy_rest, Req, State}.

allowed_methods(Req,State)->
  {[<<"PUT">>,<<"OPTIONS">>],Req,State}.

forbidden(Req,State)-> {false,Req,State}.

content_types_accepted(Req,State)->
  {[
    {{<<"application">>, <<"json">>, '*'},handle_action}
   ],Req,State}.

content_types_provided(Req,State)->
  {[
    {{<<"application">>, <<"json">>, '*'},handle_action}
   ],Req,State}.

allow_missing_post(Req,State)->{false,Req,State}.
options(Req, State) ->
  Req0 = aicow_rest:options(Req, ['PUT','OPTIONS']),
  {ok, Req0, State}.

resource_exists(#{method := <<"PUT">>} = Req,State)-> {false,Req,State}.

malformed_request(#{method := Method} = Req,State)->
  NotRequireBody = lists:member(Method, [<<"OPTIONS">>]),
  case cowboy_req:has_body(Req) of
    true ->
      if NotRequireBody == true -> {true,Req,State};
         true -> {false,Req,State}
      end;
    false ->
      if NotRequireBody == true -> {false,Req,State};
         true -> {true,Req,State}
      end
  end.

handle_action(#{method := Method} = Req,State)->
  Method0 = erlang:binary_to_atom(Method,utf8),
  Req0 = aicow_rest:allow_cors(Req, undefined),
  handle_action(Method0,Req0,State).

handle_action('PUT',Req,State)->
  {ok,Token} =
    srv_token:create([{<<"email">>,<<"david.alpha.fox@gmail.com">>}]),
  aicow_rest:json(true,#{data =>#{token => Token}}, Req, State).
