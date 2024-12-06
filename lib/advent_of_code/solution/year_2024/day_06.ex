defmodule AdventOfCode.Solution.Year2024.Day06 do
  @left {-1, 0}
  @right {1, 0}
  @up {0, -1}
  @down {0, 1}

  def part1(input) do
    {map, pos, dir} =
      input
      |> to_map_grid()

    {_, coverage} = traverse(map, pos, dir)

    coverage
    |> Enum.count(fn {_pos, c} ->
      case c do
        {"X", _} -> true
        _ -> false
      end
    end)
  end

  def part2(input) do
    {map, starting_pos, dir} =
      input
      |> to_map_grid()

    {_, map_coverage} = traverse(map, starting_pos, dir)

    map_coverage
    |> Enum.filter(fn {pos, val} ->
      case val do
        {"X", _} ->
          pos != starting_pos

        _ ->
          false
      end
    end)
    |> Enum.map(fn {pos, _val} -> pos end)
    |> Enum.filter(fn pos ->
      obs_map = Map.put(map, pos, "O")

      case traverse(obs_map, starting_pos, dir) do
        {true, _} -> true
        _ -> false
      end
    end)
    # |> IO.inspect()
    |> Enum.count()
  end

  defp traverse(map_grid, pos, dir) do
    map_grid =
      case Map.get(map_grid, pos) do
        {"X", _} -> map_grid
        _ -> Map.put(map_grid, pos, {"X", dir})
      end

    new_pos = move(pos, dir)

    case Map.get(map_grid, new_pos) do
      char when char == "#" or char == "O" ->
        new_dir = turn(dir)
        traverse(map_grid, pos, new_dir)

      "." ->
        traverse(map_grid, new_pos, dir)

      {"X", ^dir} ->
        {true, map_grid}

      {"X", _} ->
        traverse(map_grid, new_pos, dir)

      nil ->
        {false, map_grid}
    end
  end

  defp move({x, y}, {dir_x, dir_y}) do
    {x + dir_x, y + dir_y}
  end

  defp turn(dir) do
    case dir do
      @up ->
        @right

      @right ->
        @down

      @down ->
        @left

      @left ->
        @up
    end
  end

  defp to_map_grid(input) do
    starting_map =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, row} ->
        String.graphemes(line)
        |> Enum.with_index()
        |> Enum.flat_map(fn {char, col} ->
          position = {col, row}
          [{position, char}]
        end)
      end)
      |> Map.new()

    {starting_pos, c} =
      starting_map
      |> Enum.find(fn {_pos, c} -> Enum.member?([">", "<", "^", "v"], c) end)

    dir =
      case c do
        ">" -> @right
        "<" -> @left
        "^" -> @up
        "v" -> @down
      end

    {starting_map, starting_pos, dir}
  end
end
