defmodule Tracer do
  defmacro deftraceable(head, body) do
    quote bind_quoted: [
            head: Macro.escape(head, unquote: true),
            body: Macro.escape(body, unquote: true)
          ] do
      {fun_name, args_ast} = Tracer.name_and_args(head)
      {arg_names, decorated_args} = Tracer.decorate_args(args_ast)
      head = Tracer.replace_args_with_decorated_args(head, fun_name, args_ast, decorated_args)

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

  def replace_args_with_decorated_args(head, fun_name, args_ast, decorated_args) do
    Macro.postwalk(
      head,
      fn
        {fun_ast, context, old_args} when fun_ast == fun_name and old_args == args_ast ->
          {fun_ast, context, decorated_args}

        other ->
          other
      end
    )
  end

  def name_and_args({:when, _, [short_head | _]}), do: name_and_args(short_head)
  def name_and_args(short_head), do: Macro.decompose_call(short_head)

  def decorate_args([]), do: {[], []}

  def decorate_args(args_ast) when is_list(args_ast) do
    Enum.with_index(args_ast)
    |> Enum.map(&decorate_args/1)
    |> Enum.unzip()
  end

  def decorate_args({arg_ast, index}) do
    if is_tuple(arg_ast) and elem(arg_ast, 0) == :\\ do
      {:\\, _, [{optional_name, _, _}, _]} = arg_ast
      {Macro.var(optional_name, nil), arg_ast}
    else
      arg_name = Macro.var(:"arg#{index}", __MODULE__)

      full_arg =
        quote do
          unquote(arg_ast) = unquote(arg_name)
        end

      {arg_name, full_arg}
    end
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
