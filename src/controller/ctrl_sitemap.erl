-module(ctrl_sitemap).
-export([init/2]).

-include_lib("ailib/include/ai_url.hrl").
-include("include/model.hrl").

init(Req,State)->
    Which = cowboy_req:binding(title,Req),
    sitemap(Which,Req,State).

sitemap(undefined,Req,State)->
  Site = srv_site:fetch(sitemap),
  {LastMod,Total} = page(),
  Body = aiwiki_sitemap:build_index(Site, #{total => Total,
                                            lastmod => LastMod}),
  Req0 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/xml">>},
                          Body, Req),
  {ok,Req0,State};
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
page()->
  {atomic,PageTotal} = db_page:count(undefined,true),
  if
    PageTotal == 0 ->  {calendar:universal_time(),PageTotal};
    true ->
      {atomic,[Last]} = db_page:select(0,1),
      Count = erlang:round(math:ceil(PageTotal / 100)) - 1,
      {Last#page.published_at,Count}
    end.
topic(Host) ->
    Url = ai_url:parse(Host),
    Url0 = Url#ai_url{path = <<"/topic/sitemap.xml">>},
    #{<<"url">> => ai_url:build(Url0)}.
