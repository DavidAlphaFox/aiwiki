-module(aiwiki_home_controller).
-export([init/2]).
init(Req,State)->
  Context = #{<<"title">> => <<"hello aiwiki">>},
  aiwiki_view:render(<<"home/index">>,Req,State#{context => Context}).
