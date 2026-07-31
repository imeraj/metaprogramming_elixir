defmodule Sample.Validator do
  use Spark.Dsl,
    default_extensions: [
      extensions: [Sample.Validator.Dsl]
    ]

  def validate(module, data) do
    required = Sample.Validator.Info.fields_required!(module)
    fields = Sample.Validator.Info.fields(module)

    case Enum.reject(required, &Map.has_key?(data, &1)) do
      [] ->
        validate_fields(fields, data)

      missing_required_fields ->
        {:error, :missing_required_fields, missing_required_fields}
    end
  end

  defp validate_fields(fields, data) do
    Enum.reduce_while(fields, {:ok, %{}}, fn field, {:ok, acc} ->
      case Map.fetch(data, field.name) do
        {:ok, value} ->
          case validate_value(field, value) do
            {:ok, value} ->
              {:cont, {:ok, Map.put(acc, field.name, value)}}

            :error ->
              {:halt, {:error, :invalid, field.name}}
          end

        :error ->
          {:cont, {:ok, acc}}
      end
    end)
  end

  defp validate_value(field, value) do
    with true <- type_check(field, value),
         true <- check(field, value) do
      {:ok, transform(field, value)}
    else
      _ -> :error
    end
  end

  defp type_check(%{type: :string}, value) when is_binary(value), do: true
  defp type_check(%{type: :integer}, value) when is_integer(value), do: true
  defp type_check(%{type: :datetime}, %DateTime{}), do: true
  defp type_check(%{type: :datetime}, _value), do: false
  defp type_check(_field, _value), do: false

  defp check(%{check: check}, value) when is_function(check, 1), do: check.(value)
  defp check(_field, _value), do: true

  defp transform(%{transform: transform}, value) when is_function(transform, 1),
    do: transform.(value)

  defp transform(_field, value), do: value
end
