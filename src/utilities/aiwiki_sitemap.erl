-module(aiwiki_sitemap).

-include("include/model.hrl").
-include_lib("xmerl/include/xmerl.hrl").
-include_lib("ailib/include/ai_url.hrl").

-export([build_index/2,build_urlset/2]).

build_index(Site,Content)->
  SitemapIndex = sitemapindex(Site,Content),
  ai_string:to_string(xmerl:export([SitemapIndex], xmerl_xml)).
sitemapindex(Site,Content)->
  Namespace =
    #xmlNamespace{default = "http://www.sitemaps.org/schemas/sitemap/0.9",
                  nodes = []},
  Attributes =
    [#xmlAttribute{
        name = xmlns,
        value = "http://www.sitemaps.org/schemas/sitemap/0.9"
       }],
  Sitemap = sitemap(Site,Content),
  #xmlElement{name = sitemapindex,
              namespace = Namespace,
              attributes = Attributes,
              content = Sitemap}.
sitemap(Site,Content) ->
  Host = maps:get(host,Site),
  {{Y,M,D},_} = calendar:universal_time(),
  Now0 = io_lib:format("~4.10.0B-~2.10.0B-~2.10.0B",[Y,M,D]),
  Host0 = ai_url:parse(Host),
  Time = #xmlElement{name = lastmod,
                     content = [#xmlText{value = Now0}]},
  Pages = lists:map(
    fun(I)->
        Index = ai_string:to_string(I),
        Path = <<"/sitemap/pages">>,
        Host1 = Host0#ai_url{path = Path,qs = [{index,Index}]},
        Loc = #xmlElement{name = loc,
                          content = [#xmlText{value = ai_url:build(Host1)}]},
        #xmlElement{name = sitemap,
                    content = [Loc,Time]}
    end,Content),
  TagHost = Host0#ai_url{ path = <<"/sitemap/tags">>},
  TagLoc = #xmlElement{name = loc,
                       content = [#xmlText{value = ai_url:build(TagHost)}]},
  [#xmlElement{name = sitemap,content = [TagLoc,Time]}|Pages].
build_urlset(Site,Content)->
  UrlSets = urlset(Site,Content),
  ai_string:to_string(xmerl:export([UrlSets],xmerl_xml)).

urlset(Site,Content)->
  Namespace =
    #xmlNamespace{default = "http://www.sitemaps.org/schemas/sitemap/0.9",
                 nodes = [{"xsi","http://www.w3.org/2001/XMLSchema-instance"}]},
    Attributes =
    [#xmlAttribute{name = xmlns,
                   value = "http://www.sitemaps.org/schemas/sitemap/0.9"},
     #xmlAttribute{name = 'xmlns:xsi',
                   value = "http://www.w3.org/2001/XMLSchema-instance"},
     #xmlAttribute{name = 'xsi:schemaLocation',
                   value = "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"}],
  Host = maps:get(host,Site),
  Host0 = ai_url:parse(Host),
  UrlSet =
    lists:map(
      fun(I)->
          Path = maps:get(path,I),
          Priority = maps:get(priority,I,"1.0"),
          ChangeFreq = maps:get(changefreq,I,"daliy"),
          Host1 = Host0#ai_url{path = Path},
          Loc = #xmlElement{name = loc,
                            content = [#xmlText{value = ai_url:build(Host1)}]},
          PriorityElem = #xmlElement{name = priority,
                                     content = [#xmlText{value = Priority}]},
          ChangeFreqElem = #xmlElement{name = changefreq,
                                     content = [#xmlText{value = ChangeFreq}]},
          #xmlElement{name = url,
                      content = [Loc,PriorityElem,ChangeFreqElem]}
      end,Content),
  #xmlElement{name = urlset,
              namespace = Namespace,
              attributes = Attributes,
              content = UrlSet}.
