-module(util_aiwiki_pager).
-export([pagination/4,parse_pager/1]).

parse_pager(QS)->
  PageIndex = proplists:get_value(<<"pageIndex">>,QS,0),
  PageCount = proplists:get_value(<<"pageCount">>,QS,5),
  PageIndex0 = ai_string:to_integer(PageIndex),
  PageCount0 = ai_string:to_integer(PageCount),
  {PageIndex0,PageCount0}.

-spec pagination(Path::binary(),PageIndex::integer(),
                 PageCount::integer(),Size::integer()) -> list().
pagination(Path,PageIndex,PageCount,Size)->
  PageCount0 = ai_string:to_string(PageCount),
  PageIndex0 = ai_string:to_string(PageIndex - 1),
  PageIndex1 = ai_string:to_string(PageIndex + 1),
  PrevUrl = <<Path/binary,"?pageIndex=",PageIndex0/binary,"&pageCount=",PageCount0/binary>>,
  NextUrl = <<Path/binary,"?pageIndex=",PageIndex1/binary,"&pageCount=",PageCount0/binary>>,
  if
    PageIndex > 0 ->
      if PageCount > Size ->
          [
            #{title => <<"上一页"/utf8>>,enabled => true,url => PrevUrl},
            #{title => <<"下一页"/utf8>>,enabled => false}
          ];
        true ->
          [
            #{title => <<"上一页"/utf8>>,enabled => true,url => PrevUrl},
            #{title => <<"下一页"/utf8>>,enabled => true,url => NextUrl}
          ]
      end;
    true ->
      if 
        PageCount > Size ->
          [
            #{title => <<"上一页"/utf8>>,enabled => false},
            #{title => <<"下一页"/utf8>>,enabled => false}
          ];
        true ->
          [
            #{title => <<"上一页"/utf8>>,enabled => false},
            #{title => <<"下一页"/utf8>>,enabled => true,url => NextUrl}
          ]
      end
  end.
