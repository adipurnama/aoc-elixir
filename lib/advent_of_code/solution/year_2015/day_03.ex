defmodule AdventOfCode.Solution.Year2015.Day03 do
  def part1(input) do
    init_pos = {0, 0}
    init_houses = MapSet.new() |> MapSet.put(init_pos)

    String.split(input, "", trim: true)
    |> Enum.reduce({init_houses, init_pos}, fn ch, {acc, pos} ->
      new_pos = move(pos, ch)
      acc = MapSet.put(acc, new_pos)

      {acc, new_pos}
    end)
    |> elem(0)
    |> Enum.count()
  end

  def part2(input) do
    init_pos = {0, 0}
    init_houses = MapSet.new() |> MapSet.put(init_pos)

    String.split(input, "", trim: true)
    |> Enum.reduce(
      {init_houses, init_pos, init_pos, :santa},
      fn ch, {acc, santa_pos, robo_pos, turn} ->
        new_pos = if turn == :santa, do: move(santa_pos, ch), else: move(robo_pos, ch)
        acc = MapSet.put(acc, new_pos)

        if turn == :santa do
          {acc, new_pos, robo_pos, :robo}
        else
          {acc, santa_pos, new_pos, :santa}
        end
      end
    )
    |> elem(0)
    |> Enum.count()
  end

  defp move({x, y}, ch) do
    case ch do
      ">" -> {x + 1, y}
      "<" -> {x - 1, y}
      "^" -> {x, y + 1}
      "v" -> {x, y - 1}
    end
  end
end
