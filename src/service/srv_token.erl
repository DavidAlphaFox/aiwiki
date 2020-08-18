-module(srv_token).
-export([execute/2]).
-export([create/1,get_token/1]).

-define(JWT,<<"jwt">>).
-define(ALGORITHM,<<"algorithm">>).
-define(EXPIRATION,<<"expiration">>).
-define(SECRET,<<"secret">>).

execute(Req,_Env)->
  case aicow_jwt_handler:get_token(Req, <<"_session">>) of
    undefined -> false;
    Token -> has(Token)
  end.

create(Claims)->
  JWT = jwt(),
  Secret = secret(JWT),
  Algo = algorithm(JWT),
  Exp = expiration(JWT),
  aicow_token:new(Claims,Secret,Algo,Exp).

jwt()-> aiwiki_conf:get_section(?JWT).
secret(JWT)-> proplists:get_value(?SECRET,JWT).
algorithm(JWT)->  proplists:get_value(?ALGORITHM,JWT).
expiration(JWT)-> proplists:get_value(?EXPIRATION,JWT).

get_token(Req) ->
  case aicow_token:get(Req, <<"_session">>) of
    undefined -> undefined;
    Token ->
      JWT = jwt(),
      Secret = secret(JWT),
      aicow_token:verify(Token,Secret)
  end.

has(Token)->
    JWT = jwt(),
    Secret = secret(JWT),
    case aicow_token:verify(Token,Secret) of
        undefined -> false;
        _ -> true
    end.
