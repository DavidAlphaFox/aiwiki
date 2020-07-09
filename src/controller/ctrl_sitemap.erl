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
sitemap(<<"pages">>,Req,State) ->
  Site = srv_site:fetch(sitemap),
  QS = cowboy_req:parse_qs(Req),
  Index = proplists:get_value(<<"index">>,QS),
  Index0 = ai_string:to_integer(Index),
  Pages = page(Index0),
  Body = aiwiki_sitemap:build_urlset(Site,Pages),
  Req0 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/xml">>},
                          Body, Req),
  {ok,Req0,State};
  
sitemap(<<"topics">>,Req,State) ->
  Site = srv_site:fetch(sitemap),
  Topics = topic(),
  Body = aiwiki_sitemap:build_urlset(Site,Topics),
  Req0 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/xml">>},
                          Body, Req),
  {ok,Req0,State}.

page(Index)->
  {atomic,Pages} = db_page:select(Index,100),
  lists:map(
    fun(Page)->
        ID = Page#page.id,
        ID0 = ai_string:to_string(ID),
        #{path => <<"/pages/",ID0/binary>>}
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

topic() ->
  {atomic,Topics} = db_topic:select(),
  lists:map(
    fun(Topic)->
        ID = Topic#topic.id,
        ID0 = ai_string:to_string(ID),
        #{path => <<"/topics/",ID0/binary>>,
          changefreq => <<"daily">>}
    end,Topics).
