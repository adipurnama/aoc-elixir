defmodule AdventOfCode.Solution.Year2024.Day16 do
  def part1(input) do
    {maze, size, _start_pos, _end_pos} =
      AdventOfCode.MapGrid.parse_grid(input, "S", "E")

    case AdventOfCode.MazeSolver.find_paths(input, "S", "E") do
      [] ->
        "No Path Found"

      paths ->
        [{lpath, cost}] =
          paths
          |> Enum.map(fn path -> {path, cost(path)} end)
          |> Enum.sort(fn {_, c1}, {_, c2} -> c1 <= c2 end)
          |> Enum.take(1)

        AdventOfCode.MazeSolver.format_path(maze, size, lpath)
        |> IO.inspect()

        cost
    end

    # case AdventOfCode.MazeSolver.solve(input, "S", "E") do
    #   nil ->
    #     "No Path Found"
    #
    #   path ->
    #     nil
    # end
  end

  def part2(_input) do
  end

  defp cost(path) do
    [first | rest] = path

    {nturn, nfwd, _, _} =
      rest
      |> Enum.reduce({0, 0, first, {1, 0}}, fn {x, y}, {nturn, nfwd, {px, py}, dir} ->
        ndir = {x - px, y - py}
        nturn = if ndir == dir, do: nturn, else: nturn + 1
        {nturn, nfwd + 1, {x, y}, ndir}
      end)

    1000 * nturn + nfwd
  end
end
