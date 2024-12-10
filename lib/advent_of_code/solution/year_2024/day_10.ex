defmodule AdventOfCode.Solution.Year2024.Day10 do
  def part1(input) do
    grid =
      parse(input)

    grid
    |> Enum.reduce([], fn {pos, n}, acc ->
      if n == 0 do
        res = traverse(grid, pos, [], []) |> List.flatten() |> Enum.uniq()
        [res | acc]
      else
        acc
      end
    end)
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.reduce(0, fn {_pos, n}, acc -> acc + n end)
  end

  def part2(input) do
    grid =
      parse(input)

    grid
    |> Enum.reduce([], fn {pos, n}, acc ->
      if n == 0 do
        res = traverse(grid, pos, [], []) |> List.flatten()
        [res | acc]
      else
        acc
      end
    end)
    |> List.flatten()
    |> Enum.count()
  end

  defp traverse(grid, pos = {x, y}, paths, peaks) do
    n = Map.get(grid, pos)

    case n do
      9 ->
        [pos]

      nil ->
        []

      d ->
        [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
        |> Enum.filter(fn new_pos ->
          Map.get(grid, new_pos) == d + 1 and Enum.member?(grid, new_pos) == false
        end)
        |> Enum.map(fn new_pos -> traverse(grid, new_pos, [new_pos | paths], peaks) end)
    end
  end

  defp parse(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    map_grid =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line_row/1)
      |> Map.new()

    map_grid
  end

  defp parse_line_row({line, row}) do
    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.filter(fn {char, _} -> char != "." end)
    |> Enum.flat_map(fn {char, col} ->
      position = {col, row}
      [{position, String.to_integer(char)}]
    end)
  end
end
