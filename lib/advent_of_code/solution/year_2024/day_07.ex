defmodule AdventOfCode.Solution.Year2024.Day07 do
  def part1(input) do
    solve(input, ["+", "*"])
  end

  def part2(input) do
    solve(input, ["+", "*", "||"])
  end

  defp solve(input, operators) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      equation =
        line
        |> String.split(":", trim: false)

      result = Enum.at(equation, 0) |> String.to_integer()

      calibration =
        Enum.at(equation, 1)
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> generate_pairs(operators)
        |> Enum.find(fn cal ->
          correct_calibration?(result, cal)
        end)

      {result, calibration}
    end)
    |> Enum.filter(fn {_result, calibration} ->
      calibration != nil
    end)
    |> Enum.reduce(0, fn {result, _}, acc -> acc + result end)
  end

  defp correct_calibration?(result, cal) do
    cal_result =
      cal
      |> Enum.reduce_while(0, fn {n, opr}, acc ->
        cond do
          acc > result ->
            {:halt, acc}

          acc == 0 ->
            {:cont, n}

          true ->
            {:cont, apply_opr(opr, acc, n)}
        end
      end)

    cal_result == result
  end

  defp apply_opr(opr, n1, n2) do
    case opr do
      "+" ->
        n1 + n2

      "*" ->
        n1 * n2

      "||" ->
        "#{n1}#{n2}" |> String.to_integer()
    end
  end

  defp generate_pairs([], _), do: [[]]

  defp generate_pairs([h | t], list2) do
    for elem <- list2, tail <- generate_pairs(t, list2) do
      [{h, elem} | tail]
    end
  end
end
