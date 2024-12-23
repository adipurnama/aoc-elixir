defmodule AdventOfCode.Solution.Year2024.Day16Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day16

  setup do
    [
      input: """
      ###############
      #.......#....E#
      #.#.###.#.###.#
      #.....#.#...#.#
      #.###.#####.#.#
      #.#.#.......#.#
      #.#.#####.###.#
      #...........#.#
      ###.#.#####.#.#
      #...#.....#.#.#
      #.#.#.###.#.#.#
      #.....#...#.#.#
      #.###.#.#.#.#.#
      #S..#.....#...#
      ###############
      """
    ]
  end

  # @tag :skip
  test "part1", %{input: input} do
    result = part1(input)

    assert result == 7036
  end

  # @tag :skip
  test "part2", %{input: input} do
    result = part2(input)

    assert result == 45
  end
end
