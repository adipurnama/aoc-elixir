defmodule AdventOfCode.Solution.Year2024.Day12 do
  def part1(input) do
    map =
      parse(input)

    find_areas(map)
    |> Enum.reduce(0, fn {_, areas}, acc -> acc + total_price(map, areas) end)
  end

  def part2(input) do
    map = parse(input)

    find_areas(map)
    |> Enum.reduce(0, fn {_, areas}, acc -> acc + total_price_with_discount(map, areas) end)
  end

  defp find_areas(map_grid) do
    map_grid
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.update(acc, value, [key], fn existing -> [key | existing] end)
    end)
    |> Stream.map(fn {k, v} ->
      {k, cluster(v)}
    end)
  end

  defp count_price(map, area) do
    area
    |> Stream.map(fn {x, y} ->
      [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x + 1, y}]
      |> Enum.reduce(0, fn pos, acc ->
        if Map.get(map, pos) != Map.get(map, {x, y}), do: acc + 1, else: acc
      end)
    end)
    |> Enum.sum()
  end

  defp total_price(map, areas) do
    areas
    |> Stream.map(fn a -> length(a) * count_price(map, a) end)
    |> Enum.sum()
  end

  defp total_price_with_discount(map, areas) do
    areas
    |> Stream.map(fn a -> length(a) * sides(map, a) end)
    |> Enum.sum()
  end

  # count sides = counting corners
  defp sides(map, area) do
    ch =
      Map.get(map, Enum.at(area, 0))

    area
    |> Enum.reduce([], fn {x, y}, acc ->
      c =
        [
          [{x - 1, y}, {x - 1, y - 1}, {x, y - 1}],
          [{x + 1, y}, {x + 1, y - 1}, {x, y - 1}],
          [{x - 1, y}, {x - 1, y + 1}, {x, y + 1}],
          [{x + 1, y}, {x + 1, y + 1}, {x, y + 1}]
        ]
        |> Enum.reduce([], fn [s1, s2, s3], corners ->
          cond do
            # Map.get(map, s2) != ch and
            Map.get(map, s1) != ch and
                Map.get(map, s3) != ch ->
              [{s1, s3} | corners]

            Map.get(map, s1) == ch and
              Map.get(map, s3) == ch and
                Map.get(map, s2) != ch ->
              [{{x, y}, s2} | corners]

            true ->
              corners
          end
        end)

      [c | acc]
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def cluster(coordinates) do
    coordinates
    |> Enum.reduce([], &add_to_cluster(&1, &2))
    |> merge_overlapping_clusters([])
  end

  # Helper to check if a point is adjacent (only up, down, left, right)
  defp is_adjacent?({x1, y1}, {x2, y2}) do
    # up/down
    # left/right
    (x1 == x2 and abs(y1 - y2) == 1) or
      (y1 == y2 and abs(x1 - x2) == 1)
  end

  # Add a point to existing clusters or create a new one
  defp add_to_cluster(point, []) do
    [[point]]
  end

  defp add_to_cluster(point, clusters) do
    # Find clusters that the point can join
    {matching, non_matching} =
      Enum.split_with(clusters, fn cluster ->
        Enum.any?(cluster, &is_adjacent?(point, &1))
      end)

    case matching do
      [] -> [[point] | clusters]
      _ -> [[point] ++ List.flatten(matching) | non_matching]
    end
  end

  # Merge clusters that share adjacent points
  defp merge_overlapping_clusters([], result), do: result

  defp merge_overlapping_clusters([cluster | rest], result) do
    {to_merge, remaining} =
      Enum.split_with(rest, fn other_cluster ->
        Enum.any?(cluster, fn point1 ->
          Enum.any?(other_cluster, fn point2 ->
            is_adjacent?(point1, point2)
          end)
        end)
      end)

    case to_merge do
      [] ->
        merge_overlapping_clusters(rest, [cluster | result])

      _ ->
        merged = [cluster | to_merge] |> List.flatten() |> Enum.uniq()
        merge_overlapping_clusters([merged | remaining], result)
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.with_index()
    |> Stream.flat_map(fn {line, row} ->
      String.graphemes(line)
      |> Enum.with_index()
      |> Enum.flat_map(fn {char, col} ->
        position = {col, row}
        [{position, char}]
      end)
    end)
    |> Map.new()
  end
end
