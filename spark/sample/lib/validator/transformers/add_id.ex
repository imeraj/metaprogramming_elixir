defmodule Sample.Validator.Transformers.AddId do
  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    {:ok,
     Spark.Dsl.Transformer.add_entity(dsl_state, [:fields], %Sample.Validator.Dsl.ValidatorField{
       name: :id,
       type: :string
     })}
  end
end
