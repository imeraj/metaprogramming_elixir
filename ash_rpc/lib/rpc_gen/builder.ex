defmodule AshRpc.RpcGen.Builder do
  def build_validated!(otp_app) do
    otp_app
    |> build!()
    |> validate!()
    |> apply_config()
    |> validate_wire_names!()
  end

  defp build!(otp_app) do
    {:ok, manifest} = Ash.Info.Manifest.generate(otp_app: otp_app)
    manifest
  end

  defp validate!(manifest) do
    for entrypoint <- manifest.entrypoints do
      if entrypoint.action.type == :create and entrypoint.action.primary? == false do
        raise "RpcGen: non-primary create action #{inspect(entrypoint.action.name)} " <>
                "on #{inspect(entrypoint.resource)} is not supported"
      end
    end

    manifest
  end

  defp apply_config(manifest) do
    entrypoints =
      Enum.map(manifest.entrypoints, fn entrypoint ->
        methods =
          Spark.Dsl.Extension.get_entities(
            entrypoint.resource,
            [:rpc_gen]
          )

        case Enum.find(methods, &(&1.action == entrypoint.action.name)) do
          nil ->
            entrypoint

          method ->
            action =
              %{
                entrypoint.action
                | custom:
                    Map.put(
                      entrypoint.action.custom,
                      :rpc_gen,
                      %{wire_name: method.wire_name}
                    )
              }

            %{entrypoint | action: action}
        end
      end)

    %{manifest | entrypoints: entrypoints}
  end

  defp validate_wire_names!(manifest) do
    manifest.entrypoints
    |> Enum.group_by(& &1.action.custom.rpc_gen.wire_name)
    |> Enum.each(fn
      {_, [_]} ->
        :ok

      {wire_name, dupes} ->
        raise "RpcGen: wire_name #{inspect(wire_name)} used by multiple actions: " <>
                inspect(Enum.map(dupes, &{&1.resource, &1.action.name}))
    end)

    manifest
  end
end
