-module(ctrl_rss).
-export([init/2]).
-include("include/model.hrl").
init(Req,State)->
  {atomic,Pages} = db_page:select(0,5),
  Site = site(Req),
  Body = aiwiki_rss:build(Site,Pages),
  Req0 = cowboy_req:reply(200, #{<<"content-type">> => <<"application/xml">>}, Body, Req),
  {ok,Req0,State}.
site(Req)->
  Ctx =
    case db_site:fetch(host) of
      {atomic,[Host]}  -> #{host => Host#site.value};
      _ ->
        #{host => cowboy_req:header(<<"host">>,Req,<<"/">>)}
    end,
  Ctx0 =
    case db_site:fetch(brand) of
      {atomic,[Brand]} -> Ctx#{brand => Brand#site.value};
      _ -> Ctx
    end,
  case db_site:fetch(intro) of
    {atomic,[Intro]}-> Ctx0#{intro => Intro#site.value};
    _ -> Ctx0
  end.
