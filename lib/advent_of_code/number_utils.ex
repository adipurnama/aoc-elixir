defmodule AdventOfCode.NumberUtils do
  def last_digit(n) do
    abs(n) |> rem(10)
  end

  def first_digit(n), do: find_first_digit(n)
  defp find_first_digit(n) when n < 10, do: n
  defp find_first_digit(n), do: find_first_digit(div(n, 10))
end
