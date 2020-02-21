-module(aiwiki_user_model).
-export([sleep/1,wakeup/1,schema/0,attributes/0]).
-export([create/2,update/2,auth/2,select/1]).

select(Email) ->
  MatchSpec = {
          {user,'$1','_'},
          [{'==','$1',Email}],
          ['$_']},
  Fun = fun()->
            mnesia:select(user,[MatchSpec])
        end,
  case mnesia:transaction(Fun) of
    {atomic,[]} -> not_found;
    {atomic,[User]} -> proplists(User);
    {aborted,_Reason} -> not_found 
  end.

auth(Email,Password)->
  case select(Email) of
    not_found -> false;
    User -> verify(Password,User)
  end.

verify(Password,Record)->
  Digest = proplists:get_value(passwd,Record),
  case bcrypt:hashpw(Password, Digest) of
    {ok,Hash} ->
      case erlang:list_to_binary(Hash)  of
        Digest -> Record;
        _-> false
      end;
    {error,_Reason} -> false
  end.

update(Email,Password)->
  {ok,Salt} = bcrypt:gen_salt(),
  {ok,Digest} = bcrypt:hashpw(Password,Salt),
  Fun = fun()->
            Record = {user,Email,erlang:list_to_binary(Digest)},
            mnesia:write(user,Record,write)
        end,
  case mnesia:transaction(Fun) of 
    {atomic,ok} -> ok;
    {aborted,Reason} -> Reason
  end.

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
  case mnesia:transaction(Fun) of
    {atomic,ok} -> ok;
    {aborted,Reason} -> Reason 
  end.

proplists(Record)->
  [_ModelName|Values] = erlang:tuple_to_list(Record),
  Attrs = attributes(),
  lists:zip(Attrs, Values).

sleep(PropList)-> maps:from_list(PropList).
wakeup(Fields)-> maps:to_list(Fields).

attributes()->
  Fields = fields(),
  lists:map(fun(F)-> ai_db_field:name(F) end,Fields).

fields()->
  [
    ai_db_field:define(email,string,[id,not_null]),
    ai_db_field:define(passwd,string,[not_null])
  ].
schema()->
  Fields = fields(),
  ai_db_schema:define(user,Fields).
