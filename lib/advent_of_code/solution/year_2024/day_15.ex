defmodule AdventOfCode.Solution.Year2024.Day15 do
  def part1(input) do
    {{grid, size}, start, moves} =
      parse(input)

    # IO.inspect(start, label: "start_pos")
    # print_grid(grid, size)

    {new_grid, _} =
      moves
      |> Enum.reduce({grid, start}, fn dir, {ngrid, last_pos} ->
        {ngrid, last_pos} = move_grid(ngrid, size, last_pos, dir)
        # IO.inspect(last_pos, label: "last position")
        # print_grid(ngrid, size)
        {ngrid, last_pos}
      end)

    new_grid
    |> Enum.reduce(0, fn {{x, y}, v}, acc ->
      if v == "O" do
        acc + (100 * y + x)
      else
        acc
      end
    end)
  end

  def part2(_input) do
  end

  defp print_grid(grid, {w, h}) do
    0..(h - 1)
    |> Enum.map(fn y ->
      0..(w - 1)
      |> Enum.map(fn x ->
        Map.get(grid, {x, y}, ".")
      end)
      |> Enum.join()
      |> IO.inspect()
    end)
  end

  defp move_grid(grid, size, start_pos, "<") do
    move_dir(grid, size, start_pos, {-1, 0})
  end

  defp move_grid(grid, size, start_pos, ">") do
    move_dir(grid, size, start_pos, {1, 0})
  end

  defp move_grid(grid, size, start_pos, "^") do
    move_dir(grid, size, start_pos, {0, -1})
  end

  defp move_grid(grid, size, start_pos, "v") do
    move_dir(grid, size, start_pos, {0, 1})
  end

  defp move_dir(start_grid, {w, h}, start_pos, dir) do
    {ngrid, last_pos, _} =
      1..Enum.max([w, h])
      |> Enum.reduce_while({start_grid, start_pos, []}, fn _n, {ngrid, pos, to_shift} ->
        ch = Map.get(ngrid, pos)
        new_pos = move(pos, dir)

        case ch do
          nil ->
            {new_grid, last_pos} =
              apply_grid(
                ngrid,
                start_pos,
                dir,
                to_shift |> Enum.reverse()
              )

            {:halt, {new_grid, last_pos, to_shift}}

          "#" ->
            {:halt, {start_grid, start_pos, to_shift}}

          _ ->
            {:cont, {ngrid, new_pos, [ch | to_shift]}}
        end
      end)

    {ngrid, last_pos}
  end

  defp apply_grid(grid, start_pos, dir, to_shift) do
    last_pos = move(start_pos, dir)
    grid = Map.delete(grid, start_pos)

    {ngrid, _} =
      to_shift
      |> Enum.reduce({grid, last_pos}, fn e, {ngrid, cur_pos} ->
        {Map.put(ngrid, cur_pos, e), move(cur_pos, dir)}
      end)

    {ngrid, last_pos}
  end

  defp move({x, y}, {nx, ny}) do
    {x + nx, y + ny}
  end

  defp parse(input) do
    [tiles, moves] = String.split(input, "\n\n")

    nTiles =
      tiles
      |> String.split("\n", trim: true)

    size =
      nTiles
      |> Enum.reduce_while({0, 0}, fn line, _ ->
        {:halt, {String.graphemes(line) |> length(), length(nTiles)}}
      end)

    {map_grid, start} = parse_grid(tiles)

    {{map_grid, size}, start, parse_moves(moves)}
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
      |> Enum.flat_map(&parse_line_row/1)
      |> Map.new()

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
