-module(aiwiki_sitemap).

-include("include/model.hrl").
-include_lib("xmerl/include/xmerl.hrl").
-include_lib("ailib/include/ai_url.hrl").

-export([build_index/2]).

build_index(Site,Content)->
  SitemapIndex = sitemap_index(Site,Content),
  ai_string:to_string(xmerl:export([SitemapIndex], xmerl_xml)).
sitemap_index(Site,Content)->
  Namespace =
    #xmlNamespace{default = 'http://www.sitemaps.org/schemas/sitemap/0.9',
                  nodes = []},
  Attributes =
    [#xmlAttribute{
        name = xmlns,
        value = "http://www.sitemaps.org/schemas/sitemap/0.9"
       }],
  Sitemap = index_items(Site,Content),
  #xmlElement{name = sitemapindex,
              namespace = Namespace,
              attributes = Attributes,
              content = Sitemap}.
index_items(Site,Content) ->
  Host = maps:get(host,Site),
  {{Y,M,D},_} = calendar:universal_time(),
  Now0 = io_lib:format("~4.10.0B-~2.10.0B-~2.10.0B",[Y,M,D]),
  Host0 = ai_url:parse(Host),
  lists:map(
    fun(I)->
        ID = ai_string:to_string(I),
        Path = <<"/sitemap/pages">>,
        Host1 = Host0#ai_url{path = Path,qs = [{last,ID}]},
        Loc = #xmlElement{name = loc,
                          content = [#xmlText{value = ai_url:build(Host1)}]},
        Time = #xmlElement{name = lastmod,
                           content = [#xmlText{value = Now0}]},
        #xmlElement{name = sitemap,
                    content = [Loc,Time]}
    end,Content).
