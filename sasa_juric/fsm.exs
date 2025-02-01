defmodule FSM do
  @moduledoc false

  import Tracer

  fsm = [
    running: {:pause, :paused},
    running: {:stop, :stopped},
    paused: {:resume, :running}
  ]

  for {state, {action, next_state}} <- fsm do
    deftraceable(unquote(action)(unquote(state)), do: unquote(next_state))
  end

  def initial, do: :running
end

FSM.initial() |> IO.inspect()
FSM.initial() |> FSM.pause() |> IO.inspect()
FSM.initial() |> FSM.pause() |> FSM.resume() |> IO.inspect()
