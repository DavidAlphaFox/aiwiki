-module(aiwiki_page_helper).
-export([url/1,url/2]).
-export([pagination/3]).

-include_lib("ailib/include/ai_url.hrl").


url(Page)->
  Title = maps:get(<<"title">>,Page),
  ID = maps:get(<<"id">>,Page),
  EncodeTitle = ai_url:urlencode(Title),
  EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
  <<"/pages/",EncodeID/binary,"/",EncodeTitle/binary,".html">>.
url(Host,Page)->
  Path = url(Page),
  R = ai_url:parse(Host),
  R1 = R#ai_url{path = Path},
  ai_url:build(R).


pagination(PageIndex,PageCount,Length)-> 
  aiwiki_helper:pagination(<<"/pages">>,PageIndex,PageCount,Length).
