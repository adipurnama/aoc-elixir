defmodule AdventOfCode.Solution.Year2024.Day10 do
  def part1(input) do
    # input = """
    # 89010123
    # 78121874
    # 87430965
    # 96549874
    # 45678903
    # 32019012
    # 01329801
    # 10456732
    # """

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

    # {zeros, nines} =
    #   grid
    #   |> Enum.reduce({[], []}, fn {pos, n}, {zero_pos, nine_pos} ->
    #     case n do
    #       9 -> {zero_pos, [pos | nine_pos]}
    #       0 -> {[pos | zero_pos], nine_pos}
    #       _ -> {zero_pos, nine_pos}
    #     end
    #   end)
  end

  def traverse(grid, pos = {x, y}, paths, peaks) do
    if Enum.member?(paths, pos) do
      []
    else
      n = Map.get(grid, pos)

      case n do
        9 ->
          [pos]

        nil ->
          []

        d ->
          up = Map.get(grid, {x, y - 1})
          down = Map.get(grid, {x, y + 1})
          left = Map.get(grid, {x - 1, y})
          right = Map.get(grid, {x + 1, y})

          check_up =
            if Enum.member?([0, nil], up) == false and abs(d - up) == 1,
              do: traverse(grid, {x, y - 1}, [pos | paths], peaks),
              else: []

          check_down =
            if Enum.member?([0, nil], down) == false and abs(d - down) == 1,
              do: traverse(grid, {x, y + 1}, [pos | paths], peaks),
              else: []

          check_left =
            if Enum.member?([0, nil], left) == false and abs(d - left) == 1,
              do: traverse(grid, {x - 1, y}, [pos | paths], peaks),
              else: []

          check_right =
            if Enum.member?([0, nil], right) == false and abs(d - right) == 1,
              do: traverse(grid, {x + 1, y}, [pos | paths], peaks),
              else: []

          [check_up, check_down, check_left, check_right]
      end
    end
  end

  def part2(_input) do
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
