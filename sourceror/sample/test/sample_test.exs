defmodule SampleTest do
  use ExUnit.Case

  test "parses leading comments" do
    quoted =
      """
      # Comment for :a
      :a # Also a comment for :a
      """
      |> Sourceror.parse_string!()

    assert {:__block__, meta, [:a]} = quoted

    assert meta[:leading_comments] == [
             %{
               line: 1,
               text: "# Comment for :a",
               column: 1,
               next_eol_count: 1,
               previous_eol_count: 1
             },
             %{
               line: 2,
               text: "# Also a comment for :a",
               column: 4,
               next_eol_count: 1,
               previous_eol_count: 0
             }
           ]
  end

  test "parses trailing comments" do
    quoted =
      """
      def foo() do
        :ok
      # A trailing comment
      end # Not a trailing comment for :foo
      """
      |> Sourceror.parse_string!()

    assert {:__block__, block_meta, [{:def, meta, _}]} = quoted

    assert [%{line: 3, text: "# A trailing comment"}] = meta[:trailing_comments]

    assert [
             %{
               line: 4,
               column: 5,
               next_eol_count: 1,
               previous_eol_count: 0,
               text: "# Not a trailing comment for :foo"
             }
           ] =
             block_meta[:trailing_comments]
  end

  test "updates the source code" do
    source = """
    String.to_atom(foo)\
    """

    new_source =
      source
      |> Sourceror.parse_string!()
      |> Macro.postwalk(fn
        {{:., dot_meta, [{:__aliases__, alias_meta, [:String]}, :to_atom]}, call_meta, args} ->
          {{:., dot_meta, [{:__aliases__, alias_meta, [:String]}, :to_existing_atom]}, call_meta,
           args}

        quoted ->
          quoted
      end)
      |> Sourceror.to_string()

    assert new_source ==
             """
             String.to_existing_atom(foo)\
             """
  end
end
