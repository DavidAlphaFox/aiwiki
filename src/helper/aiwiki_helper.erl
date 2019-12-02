-module(aiwiki_helper).
-export([pagination/4]).
-export([resource_and_format/1]).
-export([view_model/1]).

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