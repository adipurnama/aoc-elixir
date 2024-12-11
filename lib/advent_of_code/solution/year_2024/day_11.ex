defmodule AdventOfCode.Solution.Year2024.Day11 do
  def part1(input) do
    init_cache()

    parse(input)
    |> count_stones(25)
  end

  def part2(input) do
    parse(input)
    |> count_stones(75)
  end

  # brute force
  defp blink(input, n) do
    1..n
    |> Enum.reduce(input, fn _, acc ->
      acc
      |> Enum.map(fn s ->
        blink_stone(s)
      end)
      |> List.flatten()
    end)
  end

  defp blink_stone(0), do: 1

  defp blink_stone(stone) do
    digits = Integer.digits(stone)
    len = length(digits)

    if rem(len, 2) == 0 do
      mid = div(len, 2)
      first = Enum.take(digits, mid) |> Integer.undigits()
      second = Enum.drop(digits, mid) |> Integer.undigits()
      {first, second}
    else
      2024 * stone
    end
  end

  # use ETS memo table

  def init_cache do
    if :ets.whereis(:stones_cache) != :undefined do
      :ets.delete(:stones_cache)
    end

    :ets.new(:stones_cache, [:set, :public, :named_table])
  end

  def count_stones(stones, blink) when is_list(stones) do
    stones
    |> Enum.map(&count_stones(&1, blink))
    |> Enum.sum()
  end

  def count_stones(stone, blink) do
    cache_key = {stone, blink}

    case :ets.lookup(:stones_cache, {stone, blink}) do
      [{_key, result}] ->
        result

      [] ->
        calculate_stones(stone, blink)
        |> tap(fn result ->
          :ets.insert(:stones_cache, {cache_key, result})
        end)
    end
  end

  defp calculate_stones({_first, _second}, 0), do: 2
  defp calculate_stones(_stone, 0), do: 1

  defp calculate_stones(stone, depth) do
    case blink_stone(stone) do
      {first, second} ->
        count_stones(first, depth - 1) + count_stones(second, depth - 1)

      stone ->
        count_stones(stone, depth - 1)
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.at(0)
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
