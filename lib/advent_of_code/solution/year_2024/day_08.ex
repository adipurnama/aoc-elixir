defmodule AdventOfCode.Solution.Year2024.Day08 do
  def part1(input) do
    {{nx, ny}, map_grid} = parse(input)

    map_grid
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.update(acc, value, [key], &[key | &1])
    end)
    |> Enum.reduce(%{}, fn {antenna, locations}, acc ->
      pairs = for x <- locations, y <- locations, x < y, do: [x, y]

      antinodes =
        pairs
        |> Enum.reduce([], fn [{x1, y1}, {x2, y2}], acc ->
          {diff_x, diff_y} = {-1 * (x1 - x2), -1 * (y1 - y2)}
          # {4,4} {5,2} = {-1, 2} -> {1, -2}
          # {3,6} {6,0}
          # {5,2} {4,4} = {1, -2} -> {-1, 2}
          # {6,0} {3,6}

          acc
          |> add_antinodes_part1({x1 - diff_x, y1 - diff_y}, {nx, ny})
          |> add_antinodes_part1({x2 + diff_x, y2 + diff_y}, {nx, ny})
        end)

      Map.put(acc, antenna, antinodes)
    end)
    |> Enum.reduce([], fn {_antenna, antinodes}, acc ->
      Enum.concat(acc, antinodes)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input) do
    # input = """
    # ............
    # ........0...
    # .....0......
    # .......0....
    # ....0.......
    # ......A.....
    # ............
    # ............
    # ........A...
    # .........A..
    # ............
    # ............
    # """

    {{nx, ny}, map_grid} = parse(input)

    map_grid
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.update(acc, value, [key], &[key | &1])
    end)
    |> Enum.reduce(%{}, fn {antenna, locations}, acc ->
      pairs = for x <- locations, y <- locations, x < y, do: {x, y}

      antinodes =
        pairs
        |> Enum.reduce([], fn {{x1, y1}, {x2, y2}}, acc ->
          {diff_x, diff_y} = {x1 - x2, y1 - y2}

          acc
          |> add_antinodes_part2({x1, y1}, {-1 * diff_x, -1 * diff_y}, {nx, ny})
          |> add_antinodes_part2({x2, y2}, {diff_x, diff_y}, {nx, ny})
        end)

      Map.put(acc, antenna, antinodes)
    end)
    |> Enum.reduce([], fn {_antenna, antinodes}, acc ->
      Enum.concat(acc, antinodes)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp add_antinodes_part1(list, {x, y}, {nrow, ncol}) do
    cond do
      x < 0 or x >= ncol or y < 0 or y >= nrow ->
        list

      true ->
        [{x, y} | list]
    end
  end

  defp add_antinodes_part2(list, {x1, y1}, {diff_x, diff_y}, {nrow, ncol}) do
    list = [{x1, y1} | list]

    {x, y} = {x1 + diff_x, y1 + diff_y}

    cond do
      x < 0 or x >= ncol or y < 0 or y >= nrow ->
        list

      true ->
        list
        |> add_antinodes_part2({x, y}, {diff_x, diff_y}, {nrow, ncol})
    end
  end

  defp parse(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    {nrow, ncol} =
      {length(lines), Enum.at(lines, 0) |> String.length()}

    map_grid =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line_row/1)
      |> Map.new()

    {{nrow, ncol}, map_grid}
  end

  defp parse_line_row({line, row}) do
    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.filter(fn {char, _} -> char != "." end)
    |> Enum.flat_map(fn {char, col} ->
      position = {col, row}
      [{position, char}]
    end)
  end
end
