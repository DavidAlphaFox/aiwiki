
-module(aiwiki_db_manager).
-export([load_page/1,dump_page/1]).
-export([load_topic/1]).
-export([dump_database/1,load_database/1]).

load_page(File)->
  {ok,FileData} = file:read_file(File),
  Json = jsx:decode(FileData),
  restore_page(Json).

dump_page(File) ->
  Page = snapshot_page(),
  Bin = jsx:encode(Page),
  file:write_file(File,Bin).

load_topic(File)->
  {ok,FileData} = file:read_file(File),
  Json = jsx:decode(FileData),
  restore_topic(Json).


dump_database(File)->
  Page = snapshot_page(),
  Topic = snapshot_topic(),
  Site = snapshot_site(),
  DB = [
    {<<"site">>,Site},
    {<<"page">>,Page},
    {<<"topic">>,Topic}
  ],
  Bin = jsx:encode(DB),
  file:write_file(File,Bin).

load_database(File) -> 
  {ok,FileData} = file:read_file(File),
  Json = jsx:decode(FileData),
  Page = proplists:get_value(<<"page">>,Json),
  Site = proplists:get_value(<<"site">>,Json),
  Topic = proplists:get_value(<<"topic">>,Json),
  restore_page(Page),
  restore_topic(Topic),
  restore_site(Site).

snapshot_page()->
  All = ai_db:find_all(page),
  lists:map(fun(I)->
      PublishedAt = proplists:get_value(published_at,I),
      PublishedAt0 = calendar:datetime_to_gregorian_seconds(PublishedAt),
      lists:keyreplace(published_at,1,I,{published_at,PublishedAt0})
    end,All).
snapshot_topic() -> ai_db:find_all(topic).
snapshot_site() -> ai_db:find_all(site).
restore_page(Json)->
  lists:foreach(fun(I) -> 
    ID = proplists:get_value(<<"id">>,I),
    Title = proplists:get_value(<<"title">>,I),
    Intro = proplists:get_value(<<"intro">>,I),
    Content = proplists:get_value(<<"content">>,I),
    Published = 
    case proplists:get_value(<<"published">>,I) of 
      null -> false;
      V -> V
    end,
    PublishedAt = proplists:get_value(<<"published_at">>,I),
    PublishedAt0 = calendar:gregorian_seconds_to_datetime(PublishedAt),
    TopicID = proplists:get_value(<<"topic_id">>,I),
    Item = [
           {id,ID},
           {title,Title},
           {intro,Intro},
           {content,Content},
           {published, Published},
           {published_at,PublishedAt0},
           {topic_id,TopicID}
          ],
    ai_db:persist(page,Item)
    end,Json).

restore_topic(Json)->
  lists:foreach(fun(I) -> 
      ID = proplists:get_value(<<"id">>,I),
      Title = proplists:get_value(<<"title">>,I),
      Intro = proplists:get_value(<<"intro">>,I),
      Item = [
             {id,ID},
             {title,Title},
             {intro,Intro}
            ],
      ai_db:persist(topic,Item)
      end,Json).
restore_site(Json)->
  lists:foreach(fun(I) -> 
    Key = proplists:get_value(<<"key">>,I),
    Value = proplists:get_value(<<"value">>,I),
    Item = [
            {key,Key},
            {value,Value}
          ],
      ai_db:persist(site,Item)
    end,Json).