-module(srv_site).
-include("include/model.hrl").

-export([fetch/1]).

fetch(site)->

  lists:foldl(
    fun(Key,Acc)-> fetch(Key,Acc) end,
    #{},[brand,footer])
  Ctx =

  case db_site:fetch(footer) of
    {atomic,[Row]}-> Ctx#{footer => Row#site.value};
    _ -> Ctx
  end;
fetch(header) ->
  Ctx =
    case db_site:fetch(header) of
      {atomic,[Row]} -> Ctx#{header => Row#site.value};
      _ -> #{}
    end,
  Ctx0 =
    case db_site:fetch(keywords) of
      {atomic,[Keywords]} ->
        maps:merge(Ctx,db_site:to_json(Keywords));
      _-> Ctx
    end,
  Ctx1 =
    case db_site:fetch(intro) of
      {atomic,[Intro]}->
        maps:merge(Ctx0,db_site:to_json(Intro));
      _ -> Ctx0
    end.

fetch(Key,Ctx)->
  case db_site:fetch(Key) of
    {atomic,[Row]} -> #{Key => Row#site.value};
    _ -> #{}
  end.
