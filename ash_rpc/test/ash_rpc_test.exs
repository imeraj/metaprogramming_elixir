defmodule AshRpcTest do
  use ExUnit.Case
  doctest AshRpc

  test "greets the world" do
    assert AshRpc.hello() == :world
  end
end
