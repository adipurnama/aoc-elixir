defmodule AdventOfCode.Solution.Year2015.Day02Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2015.Day02

  setup do
    [
      input: """
      2x3x4
      1x1x10
      """
    ]
  end

  # @tag :skip
  test "part1", %{input: input} do
    result = part1(input)

    assert result == 101
  end

  # @tag :skip
  test "part2", %{input: input} do
    input = """
    2x3x4
    1x1x10
    """

    result = part2(input)

    assert result == 48
  end
end
