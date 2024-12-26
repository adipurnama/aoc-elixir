defmodule AdventOfCode.Solution.Year2024.Day20 do
  def part1(input) do
    # input = """
    # ###############
    # #...#...#.....#
    # #.#.#.#.#.###.#
    # #S#...#.#.#...#
    # #######.#.#.###
    # #######.#.#...#
    # #######.#.###.#
    # ###..E#...#...#
    # ###.#######.###
    # #...###...#...#
    # #.#####.#.###.#
    # #.#...#.#.#...#
    # #.#.#.#.#.#.###
    # #...#...#...###
    # ###############
    # """
    #
    parse_input(input)
    |> cheat(2)
    |> Enum.reduce(0, fn {nsaving, freq}, acc ->
      if nsaving >= 100, do: acc + freq, else: acc
    end)
  end

  def part2(input) do
    parse_input(input)
    |> cheat(20)
    |> Enum.reduce(0, fn {nsaving, freq}, acc ->
      if nsaving >= 100, do: acc + freq, else: acc
    end)
  end

  defp cheat({graph, from, to}, ncheat) do
    spaths = Graph.get_shortest_path(graph, from, to)

    pos_step_map =
      spaths
      |> Enum.with_index()
      |> Map.new()

    #  ..o..
    #  .ooo.
    #  ooxoo
    #  .ooo.
    #  ..o..
    cheat_opts =
      for y <- -ncheat..ncheat,
          x <- -ncheat..ncheat,
          abs(x) + abs(y) <= ncheat,
          do: {x, y}

    spaths
    |> Enum.flat_map(fn {x, y} ->
      from_step_idx = Map.get(pos_step_map, {x, y})

      Enum.map(cheat_opts, fn {dx, dy} ->
        to_step_idx = Map.get(pos_step_map, {x + dx, y + dy})

        cond do
          to_step_idx == nil ->
            nil

          to_step_idx < from_step_idx ->
            nil

          true ->
            to_step_idx - from_step_idx - abs(dx) - abs(dy)
        end
      end)
      |> Enum.reject(&(&1 == nil || &1 == 0))
    end)
    |> Enum.frequencies()
  end

  defp parse_input(input) do
    grid = AdventOfCode.PathGrid.new(input)
    from = Enum.find(grid.units, &(&1.identifier == "S")) |> Map.get(:position)
    to = Enum.find(grid.units, &(&1.identifier == "E")) |> Map.get(:position)

    {grid.graph, from, to}
  end
end
