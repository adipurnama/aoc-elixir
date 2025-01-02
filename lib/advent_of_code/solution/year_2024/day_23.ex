defmodule AdventOfCode.Solution.Year2024.Day23 do
  def part1(input) do
    {edges, conns} = parse(input)

    triangles(edges, conns)
    |> Enum.count()
  end

  def part2(input) do
    {_edges, conns} = parse(input)

    Map.keys(conns)
    |> Task.async_stream(fn vertex ->
      edges = Map.get(conns, vertex)

      # find which other vertex is connected to each other, generate combinations of vx in edges
      # then check if it's all connected
      edges_all_connected =
        combinations(edges)
        |> Enum.filter(&all_connected?(conns, &1))
        |> Enum.max_by(&length/1)

      [vertex | edges_all_connected] |> Enum.sort()
    end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.max_by(&length/1)
    |> Enum.join(",")
  end

  defp triangles(edges, conns) do
    edges
    |> Enum.reduce(MapSet.new(), fn {a, b}, acc ->
      Stream.reject(edges, fn {v1, v2} ->
        {v1, v2} == {a, b} or
          (String.starts_with?(v1, "t") or String.starts_with?(v2, "t")) == false
      end)
      |> Enum.reduce(acc, fn {c, d}, inner_acc ->
        if all_connected?(conns, {a, b}, {c, d}) do
          [a, b, d] = [a, b, d] |> Enum.sort()
          MapSet.put(inner_acc, {a, b, d})
        else
          inner_acc
        end
      end)
    end)
  end

  defp all_connected?(_connections, []), do: []

  defp all_connected?(connections, [c1 | rest]) do
    Enum.all?(rest, fn c2 ->
      Map.fetch!(connections, c1) |> Enum.member?(c2)
    end) and all_connected?(connections, rest)
  end

  defp all_connected?(connections, {a, b}, {a, c}) do
    has_connection?(connections, a, c) && has_connection?(connections, b, c)
  end

  defp all_connected?(connections, {a, b}, {b, c}) do
    has_connection?(connections, a, c) && has_connection?(connections, b, c)
  end

  defp all_connected?(_, _, _), do: false

  defp has_connection?(connections, v1, v2) do
    Map.get(connections, v1)
    |> Enum.member?(v2)
  end

  defp combinations([head | tail]) do
    cs = combinations(tail)

    for c <- cs do
      [head | c]
    end ++ cs
  end

  defp combinations([]), do: [[]]

  defp parse(input) do
    edges =
      input
      |> String.split("\n", trim: true)
      |> Stream.map(fn ab ->
        [a, b] = String.split(ab, "-") |> Enum.sort()
        {a, b}
      end)

    conn =
      edges
      |> Enum.reduce(Map.new(), fn {a, b}, connections ->
        conn_a =
          case Map.get(connections, a) do
            nil -> [b]
            other -> [b | other] |> Enum.uniq()
          end

        conn_b =
          case Map.get(connections, b) do
            nil -> [a]
            other -> [a | other] |> Enum.uniq()
          end

        connections |> Map.put(b, conn_b) |> Map.put(a, conn_a)
      end)

    {edges, conn}
  end
end
