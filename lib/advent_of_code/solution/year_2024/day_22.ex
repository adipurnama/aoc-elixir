defmodule AdventOfCode.Solution.Year2024.Day22 do
  def part1(input) do
    parse_input(input)
    |> Stream.map(&next_secret_num(&1, 2000))
    |> Enum.sum()
  end

  defp next_secret_num(num, n) do
    1..n
    |> Enum.reduce(num, fn _, new_secret ->
      pt1 = (new_secret * 64) |> mix_prune(new_secret)
      pt2 = trunc(pt1 / 32) |> mix_prune(pt1)
      (pt2 * 2048) |> mix_prune(pt2)
    end)
  end

  def part2(_input) do
  end

  defp mix_prune(n, secret), do: mix(n, secret) |> prune()
  defp mix(n1, n2), do: Bitwise.bxor(n1, n2)
  defp prune(num), do: rem(num, 16_777_216)

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
  end
end
