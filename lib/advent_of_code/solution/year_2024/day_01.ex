defmodule AdventOfCode.Solution.Year2024.Day01 do
  def part1(input) do
    {left_list, right_list} = process_input(input)

    left_list_sorted = Enum.sort(left_list)  # Sort the left list
    right_list_sorted = Enum.sort(right_list)  # Sort the right list

    Enum.zip(left_list_sorted, right_list_sorted)  # Zip the two lists together
    |> Enum.map(fn {l, r} -> abs(r - l) end)  # Calculate the difference for each pair
    |> Enum.sum()  # Sum all the differences
  end

  def part2(input) do
    {left_list, right_list} = process_input(input)

    right_frequencies = Enum.frequencies(right_list)

    left_list
      |> Enum.map(fn n -> n * Map.get(right_frequencies, n, 0) end)
      |> Enum.sum()  # Sum all the differences
  end

  defp process_input(input) do
    {left_list, right_list} =
      input
      |> String.split("\n", trim: true)  # Split the input string into lines, trimming whitespace
      |> Enum.reduce({[], []}, fn line, {left_acc, right_acc} ->
        [left, right] = String.split(String.trim(line))  # Split each line into left and right
        { [String.to_integer(left) | left_acc], [String.to_integer(right) | right_acc] }
      end)

    {left_list, right_list}
  end
end
