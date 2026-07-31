defmodule Sample.Validator.Transformers.AddTimestamps do
  use Spark.Dsl.Transformer

  alias Sample.Validator.Dsl.ValidatorField

  def transform(dsl_state) do
    if Spark.Dsl.Extension.get_opt(dsl_state, [:fields], :timestamps?) do
      dsl_state =
        dsl_state
        |> Spark.Dsl.Transformer.add_entity(
          [:fields],
          %ValidatorField{
            name: :inserted_at,
            type: :datetime
          }
        )
        |> Spark.Dsl.Transformer.add_entity(
          [:fields],
          %ValidatorField{
            name: :updated_at,
            type: :datetime
          }
        )

      {:ok, dsl_state}
    else
      {:ok, dsl_state}
    end
  end
end
