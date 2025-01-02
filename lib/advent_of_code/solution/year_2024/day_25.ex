defmodule AdventOfCode.Solution.Year2024.Day25 do
  def part1(input) do
    {locks, keys} = parse(input)

    Stream.uniq(locks)
    |> Enum.reduce(0, fn l, nfits ->
      Stream.uniq(keys)
      |> Enum.reduce(nfits, fn k, nfits ->
        if fits?(l, k), do: nfits + 1, else: nfits
      end)
    end)
  end

  def part2(_input) do
  end

  defp fits?(lock_heights, key_heights) when is_list(lock_heights) and is_list(key_heights) do
    lock_heights
    |> Enum.zip(key_heights)
    |> Enum.reduce_while(true, fn {lh, kh}, fit ->
      case fits?(lh, kh) do
        true -> {:cont, fit}
        false -> {:halt, false}
      end
    end)
  end

  defp fits?(l1, k1) do
    l1 + k1 <= 5
  end

  defp parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_schematics/1)
    |> Enum.reduce({[], []}, fn {type, heights}, {lock, key} ->
      case type do
        :lock -> {lock ++ [heights], key}
        :key -> {lock, key ++ [heights]}
      end
    end)
  end

  defp parse_schematics(s) do
    schemes = String.split(s, "\n", trim: true)

    if hd(schemes) == "#####" do
      {:lock, pin_heights(tl(schemes))}
    else
      s = schemes |> Enum.reverse() |> tl()
      {:key, pin_heights(s)}
    end
  end

  defp pin_heights(schemes) do
    height_map =
      schemes
      |> Enum.reduce(Map.new(), fn line, height_map ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(height_map, fn {ch, col}, hm ->
          old_count = Map.get(hm, col, 0)
          if ch == "#", do: Map.put(hm, col, old_count + 1), else: hm
        end)
      end)

    0..4
    |> Enum.reduce([], fn n, acc -> acc ++ [Map.get(height_map, n, 0)] end)
  end
end
