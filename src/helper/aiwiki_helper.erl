-module(aiwiki_helper).
-export([pagination/4]).
-export([resource_and_format/1]).
-export([view_model/1]).
-export([token/0,csrf/3,csrf/5]).
-export([body/1]).
-export([current_session/1,new_session/1]).

-define(CSRF_SECTION, <<"csrf">>).
-define(SECRET,<<"secret">>).

pagination(Path,PageIndex,PageCount,Length)->
  PageCount0 = ai_string:to_string(PageCount),
  PageIndex0 = ai_string:to_string(PageIndex - 1),
  PageIndex1 = ai_string:to_string(PageIndex + 1),
  PrevUrl = <<Path/binary,"?pageIndex=",PageIndex0/binary,"&pageCount=",PageCount0/binary>>,
  NextUrl = <<Path/binary,"?pageIndex=",PageIndex1/binary,"&pageCount=",PageCount0/binary>>,
  if
    PageIndex > 0 ->
      if PageCount > Length ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => true,<<"url">> => PrevUrl},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => false}
          ];
        true ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => true,<<"url">> => PrevUrl},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => true,<<"url">> => NextUrl}
          ]
      end;
    true ->
      if 
        PageCount > Length ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => false},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => false}
          ];
        true ->
          [
            #{<<"title">> => <<"上一页"/utf8>>,<<"enabled">> => false},
            #{<<"title">> => <<"下一页"/utf8>>,<<"enabled">> => true,<<"url">> => NextUrl}
          ]
      end
  end.
resource_and_format(Resource)->
  case re:run(Resource,<<"(.*)\\.(.+)$">>) of 
    nomatch -> {Resource,undefined};
    {match,[_,R1,R2]} ->
      {ResourcePos,ResourceLength} = R1,
      {FormatPos,FormatLength} = R2,
      ResourceName = binary:part(Resource,ResourcePos,ResourceLength),
      Format = binary:part(Resource,FormatPos,FormatLength),
      {ResourceName,Format}
  end.

view_model(Model)->
  lists:foldl(
    fun({Key,Value},Acc) ->
      Acc#{ai_string:to_string(Key) => Value}
    end,#{},Model).


token()->
  UUID = ai_uuid:uuid_to_string(ai_uuid:get_v4(),binary_standard),
  ai_base64:encode(UUID,#{padding => false}).

csrf(Key,Session,Method,Path)->
  CSRFSection = aiwiki_conf:get_section(?CSRF_SECTION),
  Secret = proplists:get_value(?SECRET,CSRFSection),
  Payload = <<Session/binary,Key/binary,Method/binary,Path/binary>>,
  SecretPayload = crypto:block_encrypt(aes_128_ecb,Secret,Payload),
  ai_base64:encode(SecretPayload,#{padding => false}).

csrf(Session,Method,Path)->
  Key0 = crypto:strong_rand_bytes(8),
  Key1 = ai_base64:encode(Key0,#{padding => false}),
  CSRFToken = csrf(Key1,Session,Method,Path),
  {Key1,CSRFToken}.

csrf(Token,Key,Session,Method,Path)->
  CSRFToken = csrf(Key,Session,Method,Path),
  CSRFToken == Token.

read_body(Req, Acc) ->
    case cowboy_req:read_body(Req) of
        {ok, Data, Req0} -> {ok, << Acc/binary, Data/binary >>, Req0};
        {more, Data, Req0} -> read_body(Req0, << Acc/binary, Data/binary >>)
    end.

body(Req)-> read_body(Req,<<>>).

current_session(Req)->
  try cowboy_req:parse_cookies(Req) of
    Cookies -> proplists:get_value(<<"aiwiki.session">>,Cookies)
  catch 
    _:_ -> undefined
  end.


new_session(Req)->
  Token = token(),
  Req0 = cowboy_req:set_resp_cookie(<<"aiwiki.session">>, 
    Token, Req,#{http_only => true}),
  {ok,Token,Req0}.
