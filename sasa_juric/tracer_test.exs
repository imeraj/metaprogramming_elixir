defmodule TracerTest do
  import Tracer

  deftraceable foo(a, b) when a > b do
    a / b
  end

  deftraceable foo(a, b) do
    a * b
  end
end
