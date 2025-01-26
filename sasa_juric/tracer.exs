defmodule Tracer do
  defmacro trace(expression) do
    expression_string = Macro.to_string(expression)

    quote do
      result = unquote(expression)
      Tracer.input(unquote(expression_string), result)
      result
    end
  end

  def print(expression_string, result) do
    IO.puts("Result of #{expression_string}: #{inspect(result)}")
  end
end
