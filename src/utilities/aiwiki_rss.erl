-module(aiwiki_rss).
-export([build/2]).

-include("include/model.hrl").
-include_lib("xmerl/include/xmerl.hrl").
-include_lib("ailib/include/ai_url.hrl").

build(Site,Content)->
  Rss = rss(Site,Content),
  ai_string:to_string(xmerl:export([Rss],xmerl_xml)).

rss(Site,Content)->
  Namespace = #xmlNamespace{
                 default = [],
                 nodes = [{"atom",'http://www.w3.org/2005/Atom'}]
                },
  Attributes = [
                #xmlAttribute{name = version, value = "2.0"},
                #xmlAttribute{name = 'xmlns:atom',
                              nsinfo = {"xmlns","atom"},
                              value = "http://www.w3.org/2005/Atom"
                             }],
  Channel = channel(Site,Content),
  #xmlElement{name = rss,
              namespace = Namespace,
              attributes = Attributes,
              content = [Channel]
             }.
channel(Site,Content)->
  Brand = title(maps:get(brand,Site,undefined)),
  Link = host(maps:get(host,Site,undefined)),
  Desc = intro(maps:get(intro,Site,undefined)),
  Items = item(maps:get(host,Site,"/"),Content),
  #xmlElement{name = channel,
              content = [Brand,Link,Desc] ++ Items
             }.
title(undefined)-> #xmlElement{name = title};
title(Brand) ->
  #xmlElement{
     name = title,
     content = [
                #xmlText{ value = Brand }
               ]
    }.
host(undefined)-> #xmlElement{name = link};
host(Host) ->
  #xmlElement{
     name = link,
     content = [
                #xmlText{ value = Host }
               ]
    }.

intro(undefined) -> #xmlElement{name = description};
intro(Intro) ->
  #xmlElement{
     name = description,
     content = [
                #xmlText{ value = Intro }
               ]
    }.
item(_Host,[]) -> [];
item(Host,Items) ->
  Host0 = ai_url:parse(Host),
  lists:map(
    fun(I)->
        ID = ai_string:to_string(I#page.id),
        Path = <<"/pages/",ID/binary>>,
        Host1 = Host0#ai_url{path = Path},
        Brand = title(I#page.title),
        Link = host(ai_url:build(Host1)),
        Desc = intro(I#page.intro),
        #xmlElement{
           name = item,
           content = [Brand,Link,Desc]
          }
    end,Items).
