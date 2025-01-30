defmodule TracerTest do
  import Tracer

  deftraceable foo(_, 0) do
    :error
  end

  deftraceable foo(a, b) when a > b do
    a / b
  end

  deftraceable foo(a, b) do
    a * b
  end
end

IO.inspect(TracerTest.foo(10, 2))
IO.inspect(TracerTest.foo(10, 20))
IO.inspect(TracerTest.foo(10, 0))
