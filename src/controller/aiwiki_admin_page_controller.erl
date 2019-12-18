-module(aiwiki_admin_page_controller).
-export([init/2]).
init(Req,State)->
    Action = cowboy_req:binding(action,Req),
    init(Action,Req,State).
init(<<"edit.php">>,Req,State)->
    Form = aiwiki_helper:build_form(Req,<<"POST">>),
    QS = cowboy_req:parse_qs(Req),
    ID = proplists:get_value(<<"id">>, QS),
    IntID = ai_string:to_integer(ID),
    Page = ai_db:fetch(page,IntID),
    PageModel = aiwiki_helper:view_model(Page),
    Context = Form#{
                    <<"page">> => PageModel
                   },
    aiwiki_view:render(<<"admin/page/edit">>,
                       Req,State#{context => Context}).
