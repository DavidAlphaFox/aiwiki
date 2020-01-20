
-module(aiwiki_db_manager).

-export([dump_database/1,load_database/1]).



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
  Json = jiffy:decode(FileData,[return_maps]),
  Page = maps:get(<<"page">>,Json,[]),
  Site = maps:get(<<"site">>,Json,#{}),
  Topic = maps:get(<<"topic">>,Json,#{}),
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
  lists:foreach(
    fun(I) ->
        ID = maps:get(<<"id">>,I),
        Title = maps:get(<<"title">>,I),
        Intro = maps:get(<<"intro">>,I),
        Content = maps:get(<<"content">>,I),
        Published =
          case maps:get(<<"published">>,I,null) of
            null -> false;
            V -> V
          end,
        PublishedAt = maps:get(<<"published_at">>,I),
        PublishedAt0 = calendar:gregorian_seconds_to_datetime(PublishedAt),
        TopicID = maps:get(<<"topic_id">>,I),
        Item = #{
                 id => ID,
                 title => Title,
                 intro => Intro,
                 content => Content,
                 published => Published,
                 published_at => PublishedAt0,
                 topic_id => TopicID
                },
        Page = ai_db_model:new(page,Item),
        ai_db:persist(Page)
    end,Json).

restore_topic(Json)->
  lists:foreach(
    fun(I) ->
        ID = maps:get(<<"id">>,I),
        Title = maps:get(<<"title">>,I),
        Intro = maps:get(<<"intro">>,I),
        Item = #{
                 id => ID,
                 title => Title,
                 intro => Intro
                },
        Topic = ai_db_model:new(topic,Item),
        ai_db:persist(Topic)
    end,Json).
restore_site(Json)->
  lists:foreach(
    fun(I) ->
        Key = maps:get(<<"key">>,I),
        Value = maps:get(<<"value">>,I),
        Item = #{
                 key => Key,
                 value => Value
                },
        Site = ai_db_model:new(site,Item),
        ai_db:persist(Site)
    end,Json).
