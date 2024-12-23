defmodule AdventOfCode.MazeSolver do
  def solve(input, start_char, end_char) do
    {maze, size, start_pos, end_pos} =
      AdventOfCode.MapGrid.parse_grid(input, start_char, end_char)

    bfs(maze, size, start_pos, end_pos)
  end

  def format_path(maze, {w, h}, path) do
    path_set = MapSet.new(path)

    first = hd(path)
    last = List.last(path)

    0..(h - 1)
    |> Enum.reduce([], fn y, result ->
      rows =
        0..(w - 1)
        |> Enum.reduce([], fn x, acc ->
          cond do
            {x, y} in path_set and {x, y} not in [first, last] ->
              acc ++ ["X"]

            true ->
              acc ++ [Map.get(maze, {x, y})]
          end
        end)

      result ++ [rows]
    end)
  end

  # Recursive function to find all paths
  def find_paths(input, start_char, end_char) do
    {maze, size, start_pos, end_pos} =
      AdventOfCode.MapGrid.parse_grid(input, start_char, end_char)

    find_paths(maze, size, start_pos, end_pos, [], [])
  end

  defp find_paths(_maze, _size, current, finish, visited, paths) when current == finish do
    [Enum.reverse([current | visited]) | paths]
  end

  defp find_paths(maze, size, current, finish, visited, paths) do
    if current in visited do
      paths
    else
      neighbors = get_neighbors(maze, size, current, finish)

      # Mark the current position as visited
      new_visited = [current | visited]

      # Explore neighbors
      Enum.reduce(neighbors, paths, fn neighbor, acc ->
        find_paths(maze, size, neighbor, finish, new_visited, acc)
      end)
    end
  end

  defp bfs(maze, size, start, end_pos) do
    # start position and path taken
    queue = [{start, [start]}]
    visited = MapSet.new([start])

    bfs_helper(maze, size, queue, visited, end_pos)
  end

  # No path found
  defp bfs_helper(_maze, _size, [], _visited, _end_pos), do: nil

  defp bfs_helper(maze, size, [{current_pos, path} | rest], visited, end_pos) do
    if current_pos == end_pos do
      path
    else
      neighbors = get_neighbors(maze, size, current_pos, end_pos)

      new_states =
        for neighbor <- neighbors,
            not MapSet.member?(visited, neighbor) do
          # update path
          {neighbor, path ++ [neighbor]}
        end

      visited =
        Enum.reduce(new_states, visited, fn {new_pos, _}, acc ->
          MapSet.put(acc, new_pos)
        end)

      bfs_helper(maze, size, rest ++ new_states, visited, end_pos)
    end
  end

  defp get_neighbors(maze, size, {x, y}, end_pos) do
    directions = [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

    directions
    |> Enum.reduce([], fn {dx, dy}, valid_moves ->
      nx = x + dx
      ny = y + dy

      if valid_move?(maze, size, {nx, ny}, end_pos) do
        [{nx, ny} | valid_moves]
      else
        valid_moves
      end
    end)
  end

  defp valid_move?(_maze, _size, {x, y}, {x, y}), do: true

  defp valid_move?(maze, {w, h}, {x, y}, _end_pos) do
    if y < 0 or y >= h, do: false
    if x < 0 or x >= w, do: false

    Map.get(maze, {x, y}) == "."
  end
end
