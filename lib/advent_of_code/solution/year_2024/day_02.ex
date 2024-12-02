defmodule AdventOfCode.Solution.Year2024.Day02 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      |> safe_input()
    end)
    |> Enum.count(fn [res, _] -> res end)
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
      # what if we drop one level from report input line
      |> combinations()
      |> Enum.map(&safe_input/1)
      |> Enum.reduce_while([false, :noop], fn [safe, op], acc ->
          case acc do
            [true, safe_acc] ->
              {:halt, [true, safe_acc]}
            [false, _] ->
              {:cont, [safe, op]}
          end
        end)
      end)
      |> Enum.count(fn [res, _] -> res end)
  end

  defp safe_incr(n), do: n <= 3 && n >= 1
  defp safe_decr(n), do: n >= -3 && n <= -1

  defp safe_input(numlist) when is_list(numlist) do
    numlist
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce_while([false, :noop], fn [a, b], [safe, op] ->
        diff = b - a

        cond do
          op == :incr && safe_incr(diff) && safe ->
            {:cont, [true, :incr]}
          op == :decr && safe_decr(diff) && safe ->
            {:cont, [true, :decr]}
          op == :noop ->
            cond do
              safe_incr(diff) ->
                {:cont, [true, :incr]}
              safe_decr(diff) ->
                {:cont, [true, :decr]}
              true ->
                {:halt, [false, :incr]}
            end
          true ->
            {:halt, [false, :incr]}
        end
      end)
  end

  def combinations(list) do
    Enum.map(0..(length(list) - 1), fn index ->
      List.delete_at(list, index)
    end)
  end
end
