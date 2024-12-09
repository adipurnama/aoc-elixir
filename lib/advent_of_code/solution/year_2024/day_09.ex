defmodule AdventOfCode.Solution.Year2024.Day09 do
  def part1(input) do
    # input = "2333133121414131402"

    disk =
      input
      |> String.trim()
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.with_index()
      |> Enum.map(fn {part, idx} ->
        case part do
          [block, space] ->
            block_str = String.duplicate("#{idx}", block)
            space_str = String.duplicate(".", space)
            "#{block_str}#{space_str}"

          [block] ->
            String.duplicate("#{idx}", block)
        end
      end)
      |> Enum.join()
      # |> IO.inspect()
      |> String.graphemes()

    # length(disk)

    # |> IO.inspect()

    switch_dots(disk, [], [])
    |> Enum.reject(fn c -> c == "." end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {n, idx}, acc -> acc + n * idx end)
  end

  def part2(_input) do
  end

  defp switch_dots([], trailing_dots, result) do
    result ++ trailing_dots
  end

  defp switch_dots(["." | rest], trailing_dots, result) do
    {last_e, rest} = List.pop_at(rest, -1)

    case last_e do
      "." ->
        switch_dots(["." | rest], ["." | trailing_dots], result)

      n ->
        switch_dots(rest, ["." | trailing_dots], result ++ [n])
    end
  end

  defp switch_dots([n | rest], trailing_dots, result) do
    switch_dots(rest, trailing_dots, result ++ [n])
  end
end
