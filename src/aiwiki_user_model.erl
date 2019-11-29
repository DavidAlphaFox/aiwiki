-module(aiwiki_user_model).
-export([attributes/0,schema/0]).
-export([create/2]).

create(Email,Password)->
  {ok,Salt} = bcrypt:gen_salt(),
  {ok,Digest} = bcrypt:hashpw(Password,Salt),
  Fun = fun() ->
            case mnesia:read(user,Email,read) of
              [] ->
                Record = {user,Email,erlang:list_to_binary(Digest)},
                mnesia:write(user,Record,write);
              _-> mnesia:abort(already_exist)
          end
        end,
  aiwiki_db:run_transaction(Fun).

attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_schema:field_name(F) end,Fields).
fields()->
  [
    ai_db_schema:def_field(email,string,[id,not_null]),
    ai_db_schema:def_field(passwd,string,[not_null])
  ].
schema()->
  Fields = fields(),
  ai_db_schema:def_schema(user,Fields).
