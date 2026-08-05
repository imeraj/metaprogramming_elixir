defmodule AshRpc.RpcGen.Schema do
  require Logger

  @manifest Macro.escape(AshRpc.RpcGen.Builder.build_validated!(:ash_rpc))

  def manifest do
    {manifest, _} = Code.eval_quoted(@manifest)
    manifest
  end

  def wire_names do
    Enum.map(manifest().entrypoints, & &1.action.custom.rpc_gen.wire_name)
  end

  def dispatch(remote, wire_name, payload) do
    if remote == Node.self(),
      do: dispatch_local(wire_name, payload),
      else: dispatch_remote(remote, wire_name, payload)
  end

  defp dispatch_remote(remote, wire_name, payload) do
    case :rpc.call(
           remote,
           __MODULE__,
           :dispatch_local,
           [wire_name, payload]
         ) do
      {:badrpc, reason} ->
        {:error, {:remote_call_failed, remote, reason}}

      result ->
        result
    end
  end

  def dispatch_local(wire_name, payload) do
    entrypoint =
      Enum.find(manifest().entrypoints, fn e ->
        e.action.custom.rpc_gen.wire_name == wire_name
      end)

    case entrypoint do
      nil ->
        {:error, :unknown_method}

      %{resource: resource, action: action} ->
        run(resource, action, payload)
    end
  end

  defp run(resource, action, payload) do
    Logger.info("""
    Executing #{action.type} #{inspect(resource)}.#{action.name}
    on #{Node.self()}
    payload=#{inspect(payload)}
    """)

    case action.type do
      :read ->
        resource
        |> Ash.Query.for_read(action.name, payload)
        |> Ash.read()

      :create ->
        resource
        |> Ash.Changeset.for_create(action.name, payload)
        |> Ash.create()

      :update ->
        resource
        |> Ash.Changeset.for_update(action.name, payload)
        |> Ash.update()

      :destroy ->
        resource
        |> Ash.Changeset.for_destroy(action.name, payload)
        |> Ash.destroy()

      :action ->
        resource
        |> Ash.ActionInput.for_action(action.name, payload)
        |> Ash.run_action()
    end
  end
end
