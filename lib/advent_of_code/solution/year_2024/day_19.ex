defmodule AdventOfCode.Solution.Year2024.Day19 do
  def part1(input) do
    # init_cache()

    spec = parse(input)

    # Enum.count(spec.patterns, fn pattern -> ways_to_arrange(pattern, spec.towels) > 0 end)

    spec.patterns
    |> run(spec.towels)
    |> Enum.count(&(&1 > 0))
  end

  def part2(input) do
    # init_cache()

    spec = parse(input)

    spec.patterns
    |> run(spec.towels)
    |> Enum.sum()
  end

  defp run(patterns, towels) do
    # patterns
    # |> Stream.map(&ways_to_arrange(&1, towels))

    # faster
    Task.async_stream(patterns, &ways_to_arrange(&1, towels))
    |> Stream.map(fn {:ok, res} -> res end)
  end

  defp ways_to_arrange("", _towels), do: 1

  # defp ways_to_arrange(pattern, towels) do
  #   cache_key = pattern
  #
  #   case :ets.lookup(:day_17_2024_cache, cache_key) do
  #     [{_key, result}] ->
  #       result
  #
  #     [] ->
  #       towels
  #       |> Enum.reduce(0, fn towel, acc ->
  #         case pattern do
  #           ^towel <> rest_pattern -> acc + ways_to_arrange(rest_pattern, towels)
  #           _ -> acc
  #         end
  #       end)
  #       |> tap(fn result ->
  #         :ets.insert(:day_17_2024_cache, {cache_key, result})
  #       end)
  #   end
  # end

  defp ways_to_arrange(pattern, towels) do
    with nil <- Process.get(pattern) do
      towels
      |> Enum.reduce(0, fn towel, acc ->
        case pattern do
          ^towel <> rest_pattern -> acc + ways_to_arrange(rest_pattern, towels)
          _ -> acc
        end
      end)
      |> tap(fn result ->
        Process.put(pattern, result)
      end)
    end
  end

  defp parse(input) do
    [towels, patterns] = String.split(input, "\n\n", trim: true)

    %{
      towels: String.split(towels, ", ", trim: true),
      patterns: String.split(patterns, "\n", trim: true)
    }
  end

  # def init_cache do
  #   if :ets.whereis(:day_17_2024_cache) != :undefined do
  #     :ets.delete(:day_17_2024_cache)
  #   end
  #
  #   :ets.new(:day_17_2024_cache, [:set, :public, :named_table])
  # end
end
