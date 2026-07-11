defmodule Sample.Validator.Persisters.CacheFieldNames do
  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    field_names =
      dsl_state |> Spark.Dsl.Transformer.get_entities([:fields]) |> Enum.map(& &1.name)

    {:ok, Spark.Dsl.Transformer.persist(dsl_state, :field_names, field_names)}
  end
end
