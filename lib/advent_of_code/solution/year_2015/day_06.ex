defmodule AdventOfCode.Solution.Year2015.Day06 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_cmd/1)
    |> Enum.reduce(%{}, fn {cmd, {x1, y1}, {x2, y2}}, state ->
      x1..x2
      |> Enum.reduce(state, fn x, acc ->
        y1..y2
        |> Enum.reduce(acc, fn y, acc ->
          val =
            case cmd do
              :turn_on -> 1
              :turn_off -> 0
              :toggle -> if Map.get(state, {x, y}, 0) == 0, do: 1, else: 0
            end

          Map.put(acc, {x, y}, val)
        end)
      end)
    end)
    |> Stream.filter(fn val -> elem(val, 1) == 1 end)
    |> Enum.count()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Stream.map(&parse_cmd/1)
    |> Enum.reduce(%{}, fn {cmd, {x1, y1}, {x2, y2}}, state ->
      x1..x2
      |> Enum.reduce(state, fn x, acc ->
        y1..y2
        |> Enum.reduce(acc, fn y, acc ->
          val =
            case cmd do
              :turn_on -> Map.get(state, {x, y}, 0) + 1
              :turn_off -> max(Map.get(state, {x, y}, 0) - 1, 0)
              :toggle -> Map.get(state, {x, y}, 0) + 2
            end

          Map.put(acc, {x, y}, val)
        end)
      end)
    end)
    |> Enum.reduce(0, fn {_light, brightness}, acc -> acc + brightness end)
  end

  defp parse_cmd(line) do
    double_letter_regex = ~r/(\d{1,3})/

    cmd =
      cond do
        String.starts_with?(line, "turn on") -> :turn_on
        String.starts_with?(line, "turn off") -> :turn_off
        String.starts_with?(line, "toggle") -> :toggle
      end

    [x1, x1, y1, y1, x2, x2, y2, y2] =
      Regex.scan(double_letter_regex, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)

    {cmd, {x1, y1}, {x2, y2}}
  end
end
