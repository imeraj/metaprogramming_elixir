defmodule Debugger do
  defmacro log(expression) do
    if Application.get_env(:debugger, :log_level) == :debug do
      quote bind_quoted: [expression: expression] do
        IO.puts("======================")
        IO.inspect(expression)
        IO.puts("======================")

        expression
      end
    else
      expression
    end
  end
end
