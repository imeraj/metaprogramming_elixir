defmodule Sample.Validator.Verifiers.UniqueFieldNames do
  use Spark.Dsl.Verifier

  def verify(dsl_state) do
    entities = Spark.Dsl.Extension.get_entities(dsl_state, [:fields])

    case find_duplicate(entities) do
      nil ->
        :ok

      {duplicate_name, duplicate_entity} ->
        location = Spark.Dsl.Entity.anno(duplicate_entity)

        {:error,
         Spark.Error.DslError.exception(
           message: "Duplicate field name: #{inspect(duplicate_name)}",
           path: [:fields, :field, duplicate_name],
           module: Spark.Dsl.Verifier.get_persisted(dsl_state, :module),
           location: location
         )}
    end
  end

  defp find_duplicate(entities) do
    entities
    |> Enum.reduce_while(MapSet.new(), fn entity, seen ->
      if MapSet.member?(seen, entity.name) do
        {:halt, {:found, entity.name, entity}}
      else
        {:cont, MapSet.put(seen, entity.name)}
      end
    end)
    |> case do
      {:found, name, entity} ->
        {name, entity}

      _ ->
        nil
    end
  end
end
