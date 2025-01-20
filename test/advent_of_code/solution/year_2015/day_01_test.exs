defmodule AdventOfCode.Solution.Year2015.Day01Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2015.Day01

  setup do
    [
      input: """
      )())())
      """
    ]
  end

  # @tag :skip
  test "part1", %{input: input} do
    result = part1(input)

    assert result == -3
  end

  # @tag :skip
  test "part2", %{input: input} do
    input = "()())"
    result = part2(input)

    assert result == 5
  end
end
