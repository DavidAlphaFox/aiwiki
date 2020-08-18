-module(db_user).
-include("include/model.hrl").

-export([select/1,create/3,auth/2,update/3]).

select(Email) ->
  Email0 = ai_string:to_string(Email),
  MatchSpec = {#user{email = Email0, _ = '_'},
               [],['$_']},
  Fun = fun()-> mnesia:select(user,[MatchSpec]) end,
  case mnesia:transaction(Fun) of
    {atomic,[]} -> not_found;
    {atomic,[User]} -> User;
    {aborted,_Reason} -> not_found
  end.


update(pwd,Email,Pwd)->
  Email0 = ai_string:to_string(Email),
  {ok,Salt} = bcrypt:gen_salt(),
  {ok,Digest} = bcrypt:hashpw(Pwd,Salt),
  Fun =
    fun() ->
        case mnesia:read(user,Email0,read) of
          [Record] ->
            Record0 = Record#user{pwd = Digest},
            mnesia:write(user,Record0,write);
          _-> mnesia:abort(not_found)
        end
    end,
  case mnesia:transaction(Fun) of
    {atomic,ok} -> ok;
    {aborted,Reason} -> Reason
  end;
update(nick,Email,Nick) ->
  Email0 = ai_string:to_string(Email),
  Nick0 = ai_string:to_string(Nick),
  Fun =
    fun() ->
        case mnesia:read(user,Email0,read) of
          [Record] ->
            Record0 = Record#user{nick = Nick0},
            mnesia:write(user,Record0,write);
          _-> mnesia:abort(not_found)
        end
    end,
  case mnesia:transaction(Fun) of
    {atomic,ok} -> ok;
    {aborted,Reason} -> Reason
  end.

create(Email,Nick,Password)->
  Email0 = ai_string:to_string(Email),
  Nick0 = ai_string:to_string(Nick),

  {ok,Salt} = bcrypt:gen_salt(),
  {ok,Digest} = bcrypt:hashpw(Password,Salt),

  Fun =
    fun() ->
        case mnesia:read(user,Email0,read) of
          [] ->
            Record = #user{email = Email0,
                           nick = Nick0,
                           pwd = Digest},
            mnesia:write(user,Record,write);
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
  case bcrypt:hashpw(Password,erlang:list_to_binary(Digest)) of
    {ok,Hash} ->
      case Hash  of
        Digest -> Record;
        _-> false
      end;
    {error,_Reason} -> false
  end.
