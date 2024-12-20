defmodule AdventOfCode.MapGrid do
  def parse_grid(tiles, start_ch, end_ch) do
    rows =
      tiles
      |> String.split("\n", trim: true)

    map_grid =
      rows
      |> Enum.with_index()
      |> Enum.flat_map(&parse_line_row/1)
      |> Map.new()

    {
      map_grid,
      {String.length(Enum.at(rows, 0)), length(rows)},
      find_position(map_grid, start_ch),
      find_position(map_grid, end_ch)
    }
  end

  def parse_line_row({line, row}) do
    String.graphemes(line)
    |> Enum.with_index()
    |> Enum.flat_map(fn {char, col} ->
      position = {col, row}
      [{position, char}]
    end)
  end

  defp find_position(map_grid, char) do
    map_grid
    |> Enum.reduce_while(nil, fn {pos, ch}, _start_pos ->
      if ch == char do
        {:halt, pos}
      else
        {:cont, nil}
      end
    end)
  end
end
