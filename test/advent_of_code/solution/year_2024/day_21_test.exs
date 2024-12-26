defmodule AdventOfCode.Solution.Year2024.Day21Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day21

  setup do
    [
      input: """
      029A
      980A
      179A
      456A
      379A
      """
    ]
  end

  # @tag :skip
  test "part1", %{input: input} do
    result = part1(input)

    assert result == 126_384
  end

  @tag :skip
  test "part2", %{input: input} do
    result = part2(input)

    assert result
  end
end
