ExUnit.start()
Code.require_file("while.exs", __DIR__)

defmodule WhileTest do
  use ExUnit.Case
  import Loop

  test "code loaded?" do
    Code.ensure_loaded(Loop)
  end

  test "while/2 loops as long as expression is truthy" do
    pid = spawn(fn -> :timer.sleep(:infinity) end)

    send self(), :one
    while Process.alive?(pid) do
      receive do
        :one -> send self(), :two
        :two -> send self(), :three
        :three ->
          Process.exit(pid, :kill)
          send self(), :done
      end
    end
    assert_received :done
  end

  test "break/0 terminates execution" do
    send self(), :one
    while true do
      receive do
        :one -> send self(), :two
        :two -> send self(), :three
        :three ->
            send self(), :done
            Loop.break()
      end
    end
    assert_received :done
  end
end