-module(db_user).
-include("include/model.hrl").

-export([select/1,create/3,auth/2]).

select(Email) ->
  MatchSpec = {{user,'$1','_'},
               [{'==','$1',Email}],
               ['$_']},
  Fun = fun()->
            mnesia:select(user,[MatchSpec])
        end,
  case mnesia:transaction(Fun) of
    {atomic,[]} -> not_found;
    {atomic,[User]} -> User;
    {aborted,_Reason} -> not_found
  end.

create(Email,Nick,Password)->
  {ok,Salt} = bcrypt:gen_salt(),
  {ok,Digest} = bcrypt:hashpw(Password,Salt),
  Fun = fun() ->
            case mnesia:read(user,Email,read) of
              [] ->
                mnesia:write(user,#user{
                                     email = Email,
                                     nick = Nick,
                                     pwd = erlang:list_to_binary(Digest)},write);
              _-> mnesia:abort(already_exist)
          end
        end,
  case mnesia:transaction(Fun) of
    {atomic,ok} -> ok;
    {aborted,Reason} -> Reason
  end.

auth(Email,Password)->
  case select(Email) of
    not_found -> false;
    User -> verify(Password,User)
  end.

verify(Password,Record)->
  Digest = Record#user.pwd,
  case bcrypt:hashpw(Password, Digest) of
    {ok,Hash} ->
      case erlang:list_to_binary(Hash)  of
        Digest -> Record;
        _-> false
      end;
    {error,_Reason} -> false
  end.
