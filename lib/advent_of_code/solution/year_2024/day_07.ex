defmodule AdventOfCode.Solution.Year2024.Day07 do
  def part1(input) do
    solve(input, [&Kernel.+/2, &Kernel.*/2])
  end

  def part2(input) do
    solve(input, [&Kernel.+/2, &Kernel.*/2, &concat/2])
  end

  defp solve(input, operators) do
    parse_input(input)
    |> Task.async_stream(fn {result, nums} ->
      {result, valid?({result, nums}, operators)}
    end)
    |> Enum.reduce(0, fn {:ok, {result, correct}}, acc ->
      if correct, do: acc + result, else: acc
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_line/1)
  end

  defp parse_line(line) do
    [result, nums] = String.split(line, ":")

    nums =
      nums
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)

    {result |> String.to_integer(), nums}
  end

  defp valid?({total, [num]}, _), do: total == num

  defp valid?({total, [num1, num2 | list]}, operators) do
    Enum.any?(operators, fn op -> valid?({total, [op.(num1, num2) | list]}, operators) end)
  end

  # Alternative implementation for String.to_integer("#{one}#{two}") that is so much faster!
  def concat(one, two), do: one * 10 ** length(Integer.digits(two)) + two
end
