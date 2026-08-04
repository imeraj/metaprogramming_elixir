defmodule Sample do
  @moduledoc false
  alias Sample.Manifest.RpcGen.Schema

  def run do
    Sample.PersonValidator.validate(%{
      id: "1",
      name: "Meraj",
      email: "meraj.enigma@gmail.com",
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    })
    |> IO.inspect()

    Sample.PersonValidator.validate(%{id: "2", name: "Meraj", email: "meraj.enigma"})
    |> IO.inspect()

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

  defp connect(remote), do: do_connect(remote, 10)

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
    Application.fetch_env!(:sample, Sample.Manifest.RpcGen)
    |> Keyword.fetch!(:node)
  end
end
