-module(aiwiki_sitemap_controller).
-export([init/2]).
-include_lib("ailib/include/ai_url.hrl").

init(Req,State)->
    Which = cowboy_req:binding(title,Req),
    sitemap(Which,Req,State).

sitemap(undefined,Req,State)->
    HostConf = ai_db:fetch(site,<<"host">>),
    Host = proplists:get_value(value,HostConf),
    {LastMod,Pages} = page(Host),
    Topic = topic(Host),
    aiwiki_view:render(<<"xml/sitemap">>,<<"application/xml">>,
                       Req,State#{context =>
                                      #{
                                        <<"items">> => [Topic|Pages],
                                        <<"last_mod">> => LastMod
                                       }});
sitemap(<<"page">>,Req,State) ->
    QS = cowboy_req:parse_qs(Req),
    HostConf = ai_db:fetch(site,<<"host">>),
    Host = proplists:get_value(value,HostConf),
    Index = proplists:get_value(<<"index">>,QS),
    Index0 = ai_string:to_integer(Index),
    Items = page(Host,Index0),
    aiwiki_view:render(<<"xml/urlset">>,<<"application/xml">>,
                       Req,State#{context =>
                                      #{
                                        <<"items">> => Items,
                                        <<"freq">> => <<"monthly">>
                                       }});
sitemap(<<"topic">>,Req,State) ->
    Topics = ai_db:find_all(topic),
    HostConf = ai_db:fetch(site,<<"host">>),
    Host = proplists:get_value(value,HostConf),
    Url = ai_url:parse(Host),
    Items = lists:map(
      fun(Topic)->
              TopicIdx = proplists:get_value(id,Topic),
              TopicTitle = proplists:get_value(title,Topic),
              TopicPath = aiwiki_topic_helper:url(TopicIdx,TopicTitle),
              Url0 = Url#ai_url{path = TopicPath},
              #{<<"url">> => ai_url:build(Url0)}
      end,Topics),
    aiwiki_view:render(<<"xml/urlset">>,<<"application/xml">>,
                       Req,State#{context =>
                                      #{
                                        <<"items">> => Items,
                                        <<"freq">> => <<"daily">>
                                       }}).

page(Host,Index)->
    Pages = aiwiki_page_model:pagination(Index,100),
    lists:map(
      fun(P)->
              Url = aiwiki_page_helper:url(Host,P),
              #{<<"url">> => Url}
      end,Pages).
page(Host)->
    PageTotal = ai_db:count_by(page,[{published,true}]),
    Url = ai_url:parse(Host),
    if
        PageTotal == 0 -> undefined;
        true ->
            [Last] = aiwiki_page_model:pagination(0,1),
            LastMod = ai_iso8601:format(proplists:get_value(published_at,Last)),
            SitemapCount = erlang:round(math:ceil(PageTotal / 100)) - 1,
            Items = lists:map(
                      fun(I) ->
                              IndexBin = ai_string:to_string(I),
                              Query = [
                                      {<<"index">>,IndexBin}
                                     ],
                              Url0 = Url#ai_url{path = <<"/page/sitemap.xml">>,qs = Query},
                              #{
                                <<"url">> =>  ai_url:build(Url0)
                               }
                      end,lists:seq(0,SitemapCount)),
            {LastMod,Items}
    end.
topic(Host) ->
    Url = ai_url:parse(Host),
    Url0 = Url#ai_url{path = <<"/topic/sitemap.xml">>},
    #{
      <<"url">> => ai_url:build(Url0)
     }.
