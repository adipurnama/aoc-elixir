defmodule AdventOfCode.Solution.Year2015.Day02 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> parse_line(line) |> parse_area() end)
    |> Enum.reduce(0, fn {total, spare}, acc -> acc + total + spare end)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> parse_line(line) |> parse_ribbon() end)
    |> Enum.sum()
  end

  defp parse_line(line) do
    line
    |> String.split("x", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_area([l, w, h]) do
    areas = [l * w, l * h, w * h]

    total =
      areas
      |> Enum.reduce(0, fn a, acc -> acc + 2 * a end)

    {total, Enum.min(areas)}
  end

  defp parse_ribbon(sides) do
    [m1, m2, _] = Enum.sort(sides)
    ribbon = Enum.reduce(sides, 1, fn s, acc -> acc * s end)
    m1 + m1 + m2 + m2 + ribbon
  end
end
