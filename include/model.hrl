-record(page,{id :: integer(),
              title :: binary(),
              intro :: binary(),
              content :: binary(),
              published :: boolean(),
              published_at:: tuple(),
              topic:: integer()}).

-record(topic,{id :: integer(),
                title :: binary(),
                intro :: binary()}).

-record(site,{key :: string(),
              value :: term()}).

-record(user,{email :: string(),
              nick :: string(),
              pwd :: string()}).
