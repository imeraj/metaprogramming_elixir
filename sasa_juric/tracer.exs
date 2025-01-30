defmodule Tracer do
  defmacro deftraceable(head, body) do
    {fun_name, args_ast} = name_and_args(head)
    {arg_names, decorated_args} = decorate_args(args_ast)

    head =
      Macro.postwalk(
        head,
        fn
          {fun_ast, context, old_args} when fun_ast == fun_name and old_args == args_ast ->
            {fun_ast, context, decorated_args}

          other ->
            other
        end
      )

    quote do
      def unquote(head) do
        file = __ENV__.file
        line = __ENV__.line
        module = __ENV__.module

        passed_args = unquote(arg_names) |> Enum.map(&inspect/1) |> Enum.join(", ")
        function_name = unquote(fun_name)

        result = unquote(body[:do])

        loc = "#{file}(line #{line})"
        call = "#{module}.#{function_name}(#{passed_args}) = #{inspect(result)}"
        IO.puts("#{loc} #{call}")

        result
      end
    end
  end

  defp name_and_args({:when, _, [short_head | _]}) do
    name_and_args(short_head)
  end

  defp name_and_args(short_head) do
    Macro.decompose_call(short_head)
  end

  def decorate_args(args_ast) do
    for {arg_ast, index} <- Enum.with_index(args_ast) do
      arg_name = Macro.var(:"arg#{index}", __MODULE__)

      full_arg =
        quote do
          unquote(arg_ast) = unquote(arg_name)
        end

      {arg_name, full_arg}
    end
    |> Enum.unzip()
  end

  defmacro trace(expression) do
    expression_string = Macro.to_string(expression)

    quote do
      result = unquote(expression)
      Tracer.print(unquote(expression_string), result)
      result
    end
  end

  def print(expression_string, result) do
    IO.puts("Result of #{expression_string}: #{inspect(result)}")
  end
end
