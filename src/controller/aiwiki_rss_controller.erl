-module(aiwiki_rss_controller).
-export([init/2]).
init(Req,State)->
  Pages = aiwiki_page_model:pagination(0,5),
  Pages0 = lists:map(fun(M) -> 
      M0 = aiwiki_page_helper:view_model(M),
      Url = aiwiki_page_helper:url(M0),
      M0#{<<"url">> => Url}
    end,Pages),
  aiwiki_view:render(<<"xml/rss">>,<<"application/xml">>,Req,State#{context => #{
    <<"pages">> => Pages0
  }}).

