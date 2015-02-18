-module(expr_gen).
-include_lib("eqc/include/eqc.hrl").
-export([expr_gen/0,gen_env_expr/0]).

s_gen() ->
    ?SUCHTHAT(X,list(eqc_gen:choose(97,122)),length(X) > 0 andalso length(X) =<10).

atom_gen() ->
    ?LET(X, s_gen(), list_to_atom(X)).

gen_var() ->
    ?LET(A, atom_gen(), {var,A}).

gen_num() ->
    ?LET(N, choose(0,15), {num, N}).

expr_gen() ->
    ?SIZED(Size, gen_expr(Size)).

gen_expr(0) ->
    eqc_gen:oneof([gen_var(),gen_num()]);
gen_expr(Size) ->
    Left = gen_expr(Size div 2),
    Right = gen_expr(Size div 2),
    oneof([
          gen_expr(0),
          {add, Left, Right},
          {mul, Left, Right}
          ]).

gen_env_expr()->
    ?LET(Expr, expr_gen(), {Expr, create_env(Expr)}).

create_env({num,_}) ->
    [];
create_env({var, A}) ->
    [{A, random:uniform(16)-1}];
create_env({_, Left, Right}) ->
    create_env(Left) ++ create_env(Right).

