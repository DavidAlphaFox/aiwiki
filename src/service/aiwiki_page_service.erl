-module(aiwiki_page_service).
-export([pages/2,url/2,pagination/3]).
-include_lib("ailib/include/ai_url.hrl").

pages(PageIndex,PageCount)->
    Pages = aiwiki_page_model:pagination(PageIndex,PageCount),
    lists:map(fun(M) ->
                      M0 = view_model(M),
                      Url = url(M),
                      M0#{<<"url">> => Url}
              end,Pages)

pagination(PageIndex, PageCount, Length) ->
    aiwiki_pager_helper:build(<<"/pages">>, PageIndex,PageCount, Length).


url(Host, Page) ->
    Path = url(Page),
    R = ai_url:parse(Host),
    R1 = R#ai_url{path = Path},
    ai_url:build(R1).


view_model(Page) ->

    lists:foldl(
      fun ({Key, Value}, Acc) ->
              KeyBin = ai_string:to_string(Key),
              case Key of
                  published_at ->
                      PublishedAt = ai_iso8601:format(Value),
                      Acc#{KeyBin => PublishedAt};
                  _ -> Acc#{KeyBin => Value}
              end
      end,#{}, Page).

url(Page) ->
    Title = proplists:get_value(title, Page),
    ID = proplists:get_value(id, Page),
    EncodeTitle = ai_url:urlencode(Title),
    EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
    <<"/pages/", EncodeID/binary, "/", EncodeTitle/binary,".html">>.
