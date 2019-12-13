-module(aiwiki_helper).
-export([pagination/4]).
-export([resource_and_format/1]).
-export([view_model/1]).
-export([token/0,csrf/3,csrf/5]).
-export([body/1,body/2]).
-export([site/0]).

-define(CSRF_SECTION, <<"csrf">>).
-define(SECRET,<<"secret">>).

site()->
  Site = ai_db:find_all(site),
  lists:foldl(
    fun(Conf,Acc) ->
        Key = proplists:get_value(key,Conf),
        Value = proplists:get_value(value,Conf),
        Acc#{Key => Value}
    end,#{},Site).


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
  CSRFSection = chalk_conf:get_section(?CSRF_SECTION),
  Secret = proplists:get_value(?SECRET,CSRFSection),
  Payload = <<Session/binary,Key/binary,Method/binary,Path/binary>>,
  SecretPayload = crypto:hmac(sha256,Secret,Payload),
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
body(raw,Req)->
    read_body(Req,<<>>);
body(json,Req)->
    {ok,Body,Req0} = read_body(Req,<<>>),
    {ok,jiffy:decode(Body,[return_maps]),Req0}.
