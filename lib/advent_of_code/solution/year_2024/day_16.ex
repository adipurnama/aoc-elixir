defmodule AdventOfCode.Solution.Year2024.Day16 do
  alias AdventOfCode.PathGrid

  def part1(input) do
    PathGrid.new(input)
    |> do_parts()
    |> elem(0)
  end

  def part2(input) do
    PathGrid.new(input)
    |> do_parts()
    |> elem(1)
    |> MapSet.size()
  end

  defp do_parts(path_grid) do
    from = Enum.find(path_grid.units, &(&1.identifier == "S")).position
    to = Enum.find(path_grid.units, &(&1.identifier == "E")).position
    find_lowest_scores(path_grid.graph, from, to)
  end

  defp find_lowest_scores(graph, from, to) do
    queue = queue_next_states(PriorityQueue.new(), graph, {{from, :east}, [{from, :east}], 0})
    do_search(PriorityQueue.pop(queue), graph, to, %{{from, :east} => {0, []}})
  end

  defp queue_next_states(queue, graph, {pos_dir, path, score}) do
    moves = next_moves(graph, pos_dir)

    moves
    |> Enum.reduce(queue, fn {coord, facing, added_score}, queue ->
      PriorityQueue.push(
        queue,
        {coord, facing, [{coord, facing} | path], score + added_score},
        score + added_score
      )
    end)
  end

  defp next_moves(graph, {{x, y}, facing}) do
    [{{-1, 0}, :west}, {{1, 0}, :east}, {{0, -1}, :north}, {{0, 1}, :south}]
    |> Enum.map(fn {{x2, y2}, dir} ->
      {{x + x2, y + y2}, dir, if(dir == facing, do: 1, else: 1001)}
    end)
    |> Enum.filter(fn {coord, _dir, _score} -> PathGrid.floor?(graph, coord) end)
  end

  defp do_search({:empty, _queue}, _graph, _to, _seen), do: raise("No winning states!")

  defp do_search({{:value, {coord, facing, path, score}}, queue}, graph, to, seen) do
    if coord == to do
      # We've found a best path! We might have had multiple branches that combined
      # together to get to this point though
      {score, get_all_paths(path, seen)}
    else
      case Map.get(seen, {coord, facing}) do
        {^score, old_path} ->
          # We've found an alternate way of getting to this point
          # We can cut this path (but record that it existed)
          seen = Map.put(seen, {coord, facing}, {score, [path | old_path]})
          do_search(PriorityQueue.pop(queue), graph, to, seen)

        # We've seen a better way of getting to this point (skip)
        {old_score, _old_path} when old_score < score ->
          do_search(PriorityQueue.pop(queue), graph, to, seen)

        _ ->
          # Either the first time we've seen this coordinate, or this is a better way
          # of getting to it (actions are the same)
          seen = Map.put(seen, {coord, facing}, {score, path})
          queue = queue_next_states(queue, graph, {{coord, facing}, path, score})
          do_search(PriorityQueue.pop(queue), graph, to, seen)
      end
    end
  end

  # This feels rather unnecessary but I can't think of a better way to do it
  # A BFS over all of the points in the path to build all of the ways we got there
  defp get_all_paths(path, seen) do
    do_get_all_paths(path, [], MapSet.new(), seen)
  end

  defp do_get_all_paths([], [], path, _seen), do: path

  defp do_get_all_paths([], next, path, seen) do
    do_get_all_paths(List.flatten(next), [], path, seen)
  end

  defp do_get_all_paths([{coord, _} = one | rest], next, path, seen) do
    if MapSet.member?(path, coord) do
      do_get_all_paths(rest, next, path, seen)
    else
      case Map.fetch(seen, one) do
        :error ->
          do_get_all_paths(rest, next, MapSet.put(path, coord), seen)

        {:ok, {_score, points}} ->
          do_get_all_paths(rest, [points | next], MapSet.put(path, coord), seen)
      end
    end
  end
end

