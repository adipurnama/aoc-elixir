defmodule AdventOfCode.Solution.Year2024.Day18 do
  def part1(input) do
    # input = """
    # 5,4
    # 4,2
    # 4,5
    # 3,0
    # 2,1
    # 6,3
    # 2,4
    # 1,5
    # 0,6
    # 3,3
    # 2,6
    # 5,1
    # 1,2
    # 5,5
    # 2,5
    # 6,5
    # 1,4
    # 0,4
    # 6,4
    # 1,1
    # 6,1
    # 1,0
    # 0,5
    # 1,6
    # 2,0
    # """
    # {map, bytes, sz} = parse(input, 12)

    {map, _bytes, sz} = parse(input, 1024)
    map_input = print_map(map, sz - 1)

    steps =
      AdventOfCode.MazeSolver.solve(map_input, "S", "E")
      |> Enum.count()

    steps - 1
  end

  # TODO: memo optimization
  def part2(input) do
    {map, bytes, sz} = parse(input, 1024)
    rest = bytes -- Enum.take(bytes, 1024)

    {_, xy} =
      rest
      |> Enum.reduce_while({map, {nil, nil}}, fn xy, {nmap, _nxy} ->
        nmap = Map.put(nmap, xy, "#")
        map_input = print_map(nmap, sz - 1)

        steps =
          AdventOfCode.MazeSolver.solve(map_input, "S", "E")

        case steps do
          nil -> {:halt, {nmap, xy}}
          _ -> {:cont, {nmap, xy}}
        end
      end)

    xy
  end

  defp parse(input, take) do
    {bytes, max} =
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce({[], 0}, fn xy, {acc, sz} ->
        [x, y] = String.split(xy, ",")
        x = String.to_integer(x)
        y = String.to_integer(y)

        acc = acc ++ [{x, y}]

        sz = if x > sz, do: x, else: sz
        sz = if y > sz, do: y, else: sz

        {acc, sz}
      end)

    map =
      bytes
      |> Enum.take(take)
      |> Enum.reduce(%{}, fn xy, acc -> Map.put(acc, xy, "#") end)

    map = Map.put(map, {0, 0}, "S")
    map = Map.put(map, {max, max}, "E")

    {map, bytes, max + 1}
  end

  defp print_map(map, max) do
    0..max
    |> Enum.reduce([], fn y, rows ->
      r =
        0..max
        |> Enum.reduce([], fn x, row ->
          row ++ [Map.get(map, {x, y}, ".")]
        end)
        |> Enum.join("")

      rows ++ [r]
    end)
    |> Enum.join("\n")
  end
end
