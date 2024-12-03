defmodule AdventOfCode.Solution.Year2024.Day03 do
  def part1(input) do
    # Define the regex pattern for mul(x, y)
    pattern = ~r/(mul\(\d{1,3},\d{1,3}\))/

    pattern
    |> Regex.scan(input)
    |> Enum.map(fn [_match, "mul(" <> match] ->
      match
      |> String.replace(")", "")
      |> String.split(",")
    end)
    |> Enum.reduce(0, fn [a, b], acc ->
      acc + String.to_integer(a) * String.to_integer(b)
    end)
  end

  def part2(input) do
    pattern = ~r/(don't\(\)|do\(\)|mul\(\d{1,3},\d{1,3}\))/

    {_, result} =
      pattern
      |> Regex.scan(input)
      |> Enum.map(fn [_match, match] ->
        case match do
          "do()" ->
            true

          "don't()" ->
            false

          "mul(" <> any ->
            any
            |> String.replace(")", "")
            |> String.split(",")
        end
      end)
      |> Enum.reduce({true, 0}, fn cmd, {ok, acc} ->
        case cmd do
          true ->
            {true, acc}

          false ->
            {false, acc}

          [a, b] ->
            if ok do
              {true, acc + String.to_integer(a) * String.to_integer(b)}
            else
              {false, acc}
            end
        end
      end)

    result
  end
end
