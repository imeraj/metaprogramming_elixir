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
end
