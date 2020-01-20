-module(aiwiki_page_service).
-export([pages/2,url/2,pagination/3]).
-include_lib("ailib/include/ai_url.hrl").

pages(PageIndex,PageCount)->
    Pages = aiwiki_page_model:pagination(PageIndex,PageCount),
    lists:map(
      fun(M) ->
              Page = ai_db_model:fields(M),
              PublishedAt = maps:get(published_at,Page),
              PublishedAt0 = ai_iso8601:format(PublishedAt),
              Url = url(Page),
              Page#{url => Url,published_at => PublishedAt0}
      end,Pages).

pagination(PageIndex, PageCount, Length) ->
    aiwiki_pager_helper:build(<<"/pages">>, PageIndex,PageCount, Length).


url(Host, Page) ->
    Path = url(Page),
    R = ai_url:parse(Host),
    R1 = R#ai_url{path = Path},
    ai_url:build(R1).

url(Page) ->
    Title = maps:get(title,Page),
    ID = maps:get(id, Page),
    EncodeTitle = ai_url:urlencode(Title),
    EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
    <<"/pages/", EncodeID/binary, "/", EncodeTitle/binary,".html">>.
