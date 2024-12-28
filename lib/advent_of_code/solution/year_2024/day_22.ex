defmodule AdventOfCode.Solution.Year2024.Day22 do
  import AdventOfCode.NumberUtils

  def part1(input) do
    parse_input(input)
    |> Task.async_stream(&next_secret_num(&1, 2000))
    |> Stream.map(fn {:ok, res} -> elem(res, 1) end)
    |> Enum.sum()
  end

  def part2(input) do
    parse_input(input)
    |> Task.async_stream(fn num ->
      {diffs, _secret} = next_secret_num(num, 2000)
      to_sequence_map(diffs)
    end)
    |> Stream.map(fn {:ok, res} -> res end)
    |> Enum.reduce(%{}, fn seq_map, acc ->
      Map.merge(acc, seq_map, fn _k, v1, v2 -> List.flatten([v1, v2]) end)
    end)
    |> Enum.reduce({nil, 0}, fn {map_seq, banana_list}, {seq, max} ->
      n = if is_list(banana_list), do: banana_list |> Enum.sum(), else: banana_list
      if n > max, do: {map_seq, n}, else: {seq, max}
    end)
  end

  defp mix_prune(n, secret), do: mix(n, secret) |> prune()
  defp mix(n1, n2), do: Bitwise.bxor(n1, n2)
  defp prune(num), do: rem(num, 16_777_216)

  defp next_secret_num(num, n) do
    {diffs, secret} =
      1..n
      |> Enum.reduce(
        {[{last_digit(num), nil}], num},
        fn _, {nbananas, secret} ->
          {prev_nbanana, _} = List.last(nbananas)
          new_secret = next_secret_num(secret)
          nbanana = last_digit(new_secret)
          {nbananas ++ [{nbanana, nbanana - prev_nbanana}], new_secret}
        end
      )

    {diffs, secret}
  end

  defp next_secret_num(secret_num) do
    pt1 = (secret_num * 64) |> mix_prune(secret_num)
    pt2 = trunc(pt1 / 32) |> mix_prune(pt1)
    (pt2 * 2048) |> mix_prune(pt2)
  end

  defp to_sequence_map(diffs) do
    diffs
    |> Stream.chunk_every(4, 1, :discard)
    |> Enum.reduce(Map.new(), fn [{_, n1}, {_, n2}, {_, n3}, {banana, n4}], acc ->
      if n1 == nil do
        acc
      else
        case Map.get(acc, {n1, n2, n3, n4}) do
          nil -> Map.put(acc, {n1, n2, n3, n4}, banana)
          _ -> acc
        end
      end
    end)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
  end
end
