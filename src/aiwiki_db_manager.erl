
-module(aiwiki_db_manager).
-export([load_page/1,dump_page/1]).

load_page(File)->
  {ok,FileData} = file:read_file(File),
  Json = jsx:decode(FileData),
  lists:foreach(fun(I) -> 
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
           {title,Title},
           {intro,Intro},
           {content,Content},
           {published, Published},
           {published_at,PublishedAt0},
           {topic_id,TopicID}
          ],
    ai_db:persist(page,Item)
    end,Json).
dump_page(File) ->
  All = ai_db:find_all(page),
  All0 = lists:map(fun(I)->
      PublishedAt = proplists:get_value(published_at,I),
      PublishedAt0 = calendar:datetime_to_gregorian_seconds(PublishedAt),
      lists:keyreplace(published_at,1,I,{published_at,PublishedAt0})
    end,All),
  Bin = jsx:encode(All0),
  file:write_file(File,Bin).