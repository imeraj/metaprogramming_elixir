defmodule AshRpc do
  @moduledoc """
  Documentation for `AshRpc`.
  """

  alias AshRpc.RpcGen.Schema

  def run do
    remote =
      connect(remote_node())

    Schema.dispatch(remote, "posts.create", %{
      title: "Hello",
      status: :draft
    })
    |> IO.inspect()

    Schema.dispatch(remote, "posts.list", %{})
    |> IO.inspect()

    :ok
  end

  defp connect(remote), do: do_connect(remote, 20)

  defp do_connect(remote, attempts) do
    cond do
      remote == Node.self() ->
        Node.self()

      remote in Node.list() ->
        remote

      Node.connect(remote) ->
        remote

      attempts == 0 ->
        Node.self()

      true ->
        Process.sleep(500)
        do_connect(remote, attempts - 1)
    end
  end

  defp remote_node do
    Application.fetch_env!(:ash_rpc, AshRpc.RpcGen)
    |> Keyword.fetch!(:node)
  end
end
