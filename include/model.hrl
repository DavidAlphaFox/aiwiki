-record(page,{
              id :: integer(),
              title :: binary(),
              intro :: binary(),
              content :: binary(),
              published :: boolean(),
              published_at:: tuple(),
              topic:: integer()
             }).
