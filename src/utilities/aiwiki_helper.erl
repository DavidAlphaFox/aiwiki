-module(aiwiki_helper).
-export([parse_pager/1]).

-spec parse_pager(cowboy_req:req()) -> tuple().
parse_pager(QS)->
  PageIndex = proplists:get_value(<<"index">>,QS,0),
  PageCount = proplists:get_value(<<"size">>,QS,5),
  PageIndex0 = ai_string:to_integer(PageIndex),
  PageCount0 = ai_string:to_integer(PageCount),
  {PageIndex0,PageCount0}.
