defmodule AdventOfCode.Solution.Year2024.Day15 do
  def part1(input) do
    {grid, start, moves} =
      parse(input)
      |> IO.inspect()
  end

  def part2(_input) do
  end

  defp move(grid, pos, [dir | moves]) do
  end

  defp move_dir(grid, {x, y}, "<") do
    x..0
    |> Enum.reduce_while({grid, "@", {x, y}}, fn n, {ngrid, prev_ch, rpos} ->
      next_pos = {n - 1, y}

      cond do
        Map.get(grid, next_pos) == nil ->
          ngrid =
            {:halt, Map.put(ngrid, {x, y}, nil) |> Map.put(next_pos, "@")}

          {:halt, {ngrid, "@", next_pos}}

        Map.get(grid, next_pos) == "#" ->
          {:halt, {Map.put(ngrid, {x, y}, prev_ch), prev_ch, rpos}}
      end
    end)
  end

  defp parse(input) do
    [tiles, moves] = String.split(input, "\n\n")

    {map_grid, start} = parse_grid(tiles)

    {map_grid, start, parse_moves(moves)}
  end

  defp parse_moves(moves) do
    moves
    |> String.split("\n", trim: true)
    |> Enum.join()
    |> String.graphemes()
  end

  defp parse_grid(tiles) do
    map_grid =
      tiles
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {tile, row}, map_grid ->
        map_tile =
          tile
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.reduce(%{}, fn {ch, col}, tile_map ->
            if ch == "." do
              tile_map
            else
              Map.put(tile_map, {col, row}, ch)
            end
          end)

        Map.merge(map_grid, map_tile)
      end)

    start =
      map_grid
      |> Enum.reduce_while(nil, fn {pos, ch}, _start_pos ->
        if ch == "@" do
          {:halt, pos}
        else
          {:cont, nil}
        end
      end)

    {map_grid, start}
  end
end
