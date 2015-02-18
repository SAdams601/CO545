-module(expr_props).
-include_lib("eqc/include/eqc.hrl").
-export([main/0]).

expr_prop1() ->
    ?FORALL(Expr, expr_gen:expr_gen(), {Expr,[]} == expr:parse(expr:print(Expr))).

expr_prop2() ->
    ?FORALL({Expr, Env}, expr_gen:gen_env_expr(), expr:eval(Env,Expr) == expr:execute(Env,Expr)).

main() ->
    io:format("=====Checking parse . print is id. ====="),
    eqc:quickcheck(expr_prop1()),
    io:format("====Checking eval == execute====="),
    eqc:quickcheck(expr_prop2()).
