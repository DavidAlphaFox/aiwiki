-module(aiwiki_admin_helper).
-export([menus/1]).
-define(MENUS,[
  #{
    <<"title">> => <<"文章"/utf8>>,
    <<"url">> => <<"/admin/pages.php">> 
  },
  #{
    <<"title">> => <<"站点"/utf8>>,
    <<"url">> => <<"/admin/site.php">> 
  },
  #{
    <<"title">> => <<"用户"/utf8>>,
    <<"url">> => <<"/admin/users.php">>  
  }
]).

menus(Title)->
  lists:map(fun(M) ->
      case maps:get(<<"title">>,M) of 
        Title -> M#{<<"selected">> => true};
        _ -> M#{<<"selected">> => false}
      end 
    end,?MENUS).
