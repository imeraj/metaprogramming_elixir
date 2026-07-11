defmodule Sample.Validator.Transformers.GenerateValidate do
  use Spark.Dsl.Transformer

  def transform(dsl_state) do
    validate =
      quote do
        def validate(data) do
          Sample.Validator.validate(__MODULE__, data)
        end
      end

    {:ok, Spark.Dsl.Transformer.eval(dsl_state, [], validate)}
  end
end
