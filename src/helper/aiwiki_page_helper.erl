-module(aiwiki_page_helper).
-export([url/1, url/2]).
-export([pagination/3]).
-export([view_model/1]).

-include_lib("ailib/include/ai_url.hrl").

url(Page) ->
    Title = proplists:get_value(title, Page),
    ID = proplists:get_value(id, Page),
    EncodeTitle = ai_url:urlencode(Title),
    EncodeID = ai_url:urlencode(ai_string:to_string(ID)),
    <<"/pages/", EncodeID/binary, "/", EncodeTitle/binary,".html">>.

url(Host, Page) ->
    Path = url(Page),
    R = ai_url:parse(Host),
    R1 = R#ai_url{path = Path},
    ai_url:build(R1).

pagination(PageIndex, PageCount, Length) ->
    aiwiki_helper:pagination(<<"/pages">>, PageIndex,PageCount, Length).

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
