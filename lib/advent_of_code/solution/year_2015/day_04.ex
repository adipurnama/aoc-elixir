defmodule AdventOfCode.Solution.Year2015.Day04 do
  def part1(_input) do
    input = "yzbqklnj"

    0..1_000_000
    |> Enum.find(fn n ->
      String.starts_with?(md5_hash_string(input <> Integer.to_string(n)), "00000")
    end)
  end

  def part2(_input) do
    input = "yzbqklnj"

    0..100_000_000
    |> Enum.find(fn n ->
      String.starts_with?(md5_hash_string(input <> Integer.to_string(n)), "000000")
    end)
  end

  defp md5_hash_string(str) do
    :crypto.hash(:md5, str) |> Base.encode16(case: :lower)
  end
end
