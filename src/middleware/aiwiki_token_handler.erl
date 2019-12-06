-module(aiwiki_token_handler).
-export([execute/2]).
-export([create/1,session/1]).

-define(AUTHORIZATION,<<"authorization">>).
-define(JWT,<<"jwt">>).
-define(ALGORITHM,<<"algorithm">>).
-define(EXPIRATION,<<"expiration">>).
-define(SECRET,<<"secret">>).

execute(Req,_Env)->
    case token(Req) of
        undefined -> false;
        Token -> has(Token)
    end.


create(Claims)->
    JWT = jwt(),
    Secret = secret(JWT),
    Algo = algorithm(JWT),
    case expiration(JWT) of
        undefined -> jwt:encode(Algo,Claims,Secret);
        Expiration ->jwt:encode(Algo, Claims, Expiration,Secret)
    end.

jwt()-> aiwiki_conf:get_section(?JWT).
secret(JWT)-> proplists:get_value(?SECRET,JWT).
algorithm(JWT)->  proplists:get_value(?ALGORITHM,JWT).
expiration(JWT)-> proplists:get_value(?EXPIRATION,JWT).

session(Req) ->
    case token(Req) of
        undefined -> undefined;
        Token -> verify(Token)
    end.

verify(Token) ->
    JWT = jwt(),
    Secret = secret(JWT),
    case jwt:decode(Token, Secret) of
        {ok,Claims} -> {Token,Claims};
        _ -> undefined
    end.


token(Req)->
    case cowboy_req:header(?AUTHORIZATION,Req) of
        undefined ->
            QS = cowboy_req:parse_qs(Req),
            proplists:get_value(<<"_session">>,QS);
        Auth ->
            <<"Bearer ",Token/binary>> = Auth,
            Token
    end.

has(Token)->
    JWT = jwt(),
    Secret = secret(JWT),
    case jwt:decode(Token, Secret) of
        {ok, _Claims} -> true;
        _ -> false
    end.
