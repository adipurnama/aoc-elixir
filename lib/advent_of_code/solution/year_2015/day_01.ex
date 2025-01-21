defmodule AdventOfCode.Solution.Year2015.Day01 do
  def part1(input) do
    input
    |> String.replace(" ", "")
    |> String.graphemes()
    |> Enum.reduce(0, fn ch, acc ->
      move(acc, ch)
    end)
  end

  def part2(input) do
    input
    |> String.replace(" ", "")
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce_while(0, fn {ch, idx}, pos ->
      case move(pos, ch) do
        -1 ->
          {:halt, idx + 1}

        res ->
          {:cont, res}
      end
    end)
  end

  defp move(pos, ch) do
    case ch do
      "(" -> pos + 1
      ")" -> pos - 1
      _ -> pos
    end
  end
end
