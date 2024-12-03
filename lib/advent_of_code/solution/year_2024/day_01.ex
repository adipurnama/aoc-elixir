defmodule AdventOfCode.Solution.Year2024.Day01 do
  def part1(input) do
    {left_list, right_list} = process_input(input)

    # Sort the left list
    left_list_sorted = Enum.sort(left_list)
    # Sort the right list
    right_list_sorted = Enum.sort(right_list)

    # Zip the two lists together
    Enum.zip(left_list_sorted, right_list_sorted)
    # Calculate the difference for each pair
    |> Enum.map(fn {l, r} -> abs(r - l) end)
    # Sum all the differences
    |> Enum.sum()
  end

  def part2(input) do
    {left_list, right_list} = process_input(input)

    right_frequencies = Enum.frequencies(right_list)

    left_list
    |> Enum.map(fn n -> n * Map.get(right_frequencies, n, 0) end)
    # Sum all the differences
    |> Enum.sum()
  end

  defp process_input(input) do
    {left_list, right_list} =
      input
      # Split the input string into lines, trimming whitespace
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], []}, fn line, {left_acc, right_acc} ->
        # Split each line into left and right
        [left, right] = String.split(String.trim(line))
        {[String.to_integer(left) | left_acc], [String.to_integer(right) | right_acc]}
      end)

    {left_list, right_list}
  end
end
