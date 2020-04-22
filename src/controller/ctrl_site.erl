-module(ctrl_site).
-export([init/2]).
-export([
         content_types_accepted/2,
         content_types_provided/2,
         allow_missing_post/2,
         resource_exists/2,
         allowed_methods/2,
         malformed_request/2,
         forbidden/2
        ]).
-export([handle_action/2]).


init(Req, State) -> {cowboy_rest, Req, State}.

allowed_methods(Req,State)->
  {[<<"GET">>,<<"POST">>,<<"PUT">>],Req,State}.

forbidden(Req,State)-> {false,Req,State}.

content_types_accepted(Req,State)->
    Processors =
        [
         {{<<"application">>, <<"json">>, '*'},handle_action}
        ],
    {Processors,Req,State}.
content_types_provided(Req,State)->
    Processors =
        [
         {{<<"application">>, <<"json">>, '*'},handle_action}
        ],
    {Processors,Req,State}.
allow_missing_post(Req,State)->{false,Req,State}.

resource_exists(#{method := <<"POST">>} = Req,State)-> {true,Req,State};
resource_exists(#{method := <<"PUT">>} = Req,State)-> {false,Req,State};
resource_exists(#{method := <<"GET">>} = Req,State) -> {true,Req,State}.

malformed_request(#{method := Method} = Req,State)->
  case {Method, cowboy_req:has_body(Req)} of
    {<<"GET">>,true} -> {true,Req,State};
    {<<"GET">>,false} -> {false,Req,State};
    {_,false} -> {true,Req,State};
    {_,true} -> {false,Req,State}
  end.

handle_action(#{method := Method} = Req,State)->
  Method0 = erlang:binary_to_atom(Method,utf8),
  Type = cowboy_req:binding(id,Req),
  handle_action(Method0,Type,Req,State).

handle_action('GET',<<"site">>,Req,State)->

  {jiffy:encode(Ctx0),Req,State};
handle_action('GET',<<"header">>,Req,State) ->
  Ctx =
    case db_site:fetch(header) of
      {atomic,[Header]} -> db_site:to_json(Header);
      _ -> #{}
    end,
  Ctx0 =
    case db_site:fetch(keywords) of
      {atomic,[Keywords]} ->
        maps:merge(Ctx,db_site:to_json(Keywords));
      _-> Ctx
    end,
  Ctx1 =
    case db_site:fetch(intro) of
      {atomic,[Intro]}->
        maps:merge(Ctx0,db_site:to_json(Intro));
      _ -> Ctx0
    end,
  {jiffy:encode(Ctx1),Req,State}.
