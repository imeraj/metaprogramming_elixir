defmodule Assertions do
  defmacro assert({operator, _, [lhs, rhs]} = expr)
           when operator in [:==, :<, :>, :<=, :>=, :==, :===, :=~, :!==, :!=, :in] do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      expr = unquote(Macro.to_string(expr))

      result = unquote(operator)(lhs, rhs)

      if result do
        IO.puts(".")
      else
        IO.puts("Assertion with #{unquote(operator)} failed")
        IO.puts("code: #{expr}")
        IO.puts("lhs: #{lhs}")
        IO.puts("rhs: #{rhs}")
      end
    end
  end
end
