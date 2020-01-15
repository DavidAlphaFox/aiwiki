 -module(aiwiki_admin_page_controller).
-export([init/2]).
init(Req,State)->
    Action = cowboy_req:binding(action,Req),
    init(Action,Req,State).
init(<<"edit.php">>,#{method := <<"GET">> } = Req,State) ->
    Form = aiwiki_helper:build_form(Req,<<"POST">>),
    QS = cowboy_req:parse_qs(Req),
    ID = proplists:get_value(<<"id">>, QS),
    IntID = ai_string:to_integer(ID),
    Page = ai_db:fetch(page,IntID),
    TopicID = proplists:get_value(topic_id,Page),
    Topics = aiwiki_topic_helper:select(TopicID),
    PageModel = aiwiki_helper:view_model(Page),
    Context = Form#{
                    <<"topics">> => Topics,
                    <<"page">> => PageModel
                   },
    aiwiki_view:render(<<"admin/page/edit">>,
                       Req,State#{context => Context});
init(<<"edit.php">>,#{method := <<"POST">> } = Req,State) ->
    {ok,Body,Req0} = aiwiki_helper:body(Req),
    R = ai_url:parse_query(Body),
    Session = aiwiki_session_handler:session_id(Req),
    case aiwiki_helper:verify_form(Req,R) of
        false -> aiwiki_view:error(400,Req0,State);
        true -> action(edit,Req0,State#{form => R})
    end.
action(edit,Req,#{form := R} = State)->
    QS = cowboy_req:parse_qs(Req),
    Topic = proplists:get_value(<<"topic">>,R),
    IntTopic = ai_string:to_integer(Topic),
    Published =
        case proplists:get_value(<<"published">>,R) of
            undefined -> false;
            V -> ai_string:to_boolean(V)
        end,
    Title = proplists:get_value(<<"title">>,R),
    Content = proplists:get_value(<<"content">>,R),
    Intro = proplists:get_value(<<"intro">>,R),
    Page = aiwiki_page_model:build(Title,Intro,Content,IntTopic,Published),
    ID = proplists:get_value(<<"id">>, QS),
    IntID = ai_string:to_integer(ID),
    Page1 = ai_db:fetch(page,IntID),
    PageModel = aiwiki_helper:view_model(Page1),

    Form = aiwiki_helper:build_form(Req,<<"POST">>),
    Context = Form#{
                    <<"page">> => PageModel
                   },
    aiwiki_view:render(<<"admin/page/edit">>,
                       Req,State#{context => Context}).
