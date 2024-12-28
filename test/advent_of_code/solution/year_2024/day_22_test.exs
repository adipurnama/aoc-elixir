defmodule AdventOfCode.Solution.Year2024.Day22Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day22

  setup do
    [
      input: """
      1
      10
      100
      2024
      """
    ]
  end

  # @tag :skip
  test "part1", %{input: input} do
    result = part1(input)

    assert result == 37_327_623
  end

  # @tag :skip
  test "part2", %{input: input} do
    input = """
    1
    2
    3
    2024
    """

    result = part2(input)

    assert result == {{-2, 1, -1, 3}, 23}
  end
end
