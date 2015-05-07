-module(idiomatic).
-include_lib("eunit/include/eunit.hrl").
-export([fibonacci/1, zero_is_okay/1, factorializer/1]).

fibonacci(0) -> 0;
fibonacci(1) -> 1;
fibonacci(N) -> fibonacci(N-1) + fibonacci(N-2).

zero_is_okay(0) -> ok.

factorializer(0) -> 0;
factorializer(1) -> 1;
factorializer(N) when N > 1 -> N * factorializer(N-1).

factorializer_test() ->
  120 = factorializer(6).

factorializer_test_() ->
  ?_assert(120 =:= factorializer(6)).
