-module(ctrl_rss).
-export([init/2]).
-include("include/model.hrl").
init(Req,State)->
  {atomic,Pages} = db_page:select(0,5),
  Site = srv_site:fetch(rss),
  Body = aiwiki_rss:build(Site,Pages),
  Req0 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/xml">>},
                          Body, Req),
  {ok,Req0,State}.
