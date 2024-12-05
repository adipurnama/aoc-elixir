defmodule AdventOfCode.Solution.Year2024.Day04 do
  @dirs [
    {-1, 0}, # left
    {1, 0}, # right
    {0, -1}, # up
    {0, 1}, # down
    {-1, -1}, # left-up
    {-1, 1}, # left-down
    {1, -1}, # right-up
    {1, 1} # right-down
  ]

  def part1(input) do
    map_grid =
      input
      |> String.split("\n", trim: true)
      |> map_grid

    word = String.graphemes("XMAS")

    map_grid
    |> Enum.reduce(0, fn {pos, char}, acc ->
      if char == "X" do
        count =
          @dirs
          |> Enum.reduce(0, fn dir, n ->
            case matches?(map_grid, word, pos, dir) do
              true -> n + 1
              false -> n
            end
          end)

        acc + count
      else
        acc
      end
    end)
  end

  def part2(input) do
    map_grid =
      input
      |> String.split("\n", trim: true)
      |> map_grid

    map_grid
    |> Enum.reduce(0, fn {pos, char}, acc ->
      if char == "A" do
        case a_matches_x_mas?(map_grid, pos) do
          true -> acc + 1
          false -> acc
        end
      else
        acc
      end
    end)
  end

  defp matches?(map_grid, [c | rest_word], pos, direction) do
    case at(map_grid, pos) do
      ^c ->
        new_pos = move(pos, direction)
        matches?(map_grid, rest_word, new_pos, direction)
      _ ->
        false
    end
  end
  defp matches?(_, [], _, _), do: true

  defp a_matches_x_mas?(map_grid, pos) do
    a_right_diagonal_matches_mas(map_grid, pos) && a_left_diagonal_matches_mas(map_grid, pos)
  end

  defp a_left_diagonal_matches_mas(map_grid, pos) do
    (at(map_grid, move(pos, {-1, -1})) == "S" && at(map_grid, move(pos, {1, 1})) == "M")
      || (at(map_grid, move(pos, {-1, -1})) == "M" && at(map_grid, move(pos, {1, 1})) == "S")
  end

  defp a_right_diagonal_matches_mas(map_grid, pos) do
    (at(map_grid, move(pos, {1, -1})) == "S" && at(map_grid, move(pos, {-1, 1})) == "M")
      || (at(map_grid, move(pos, {1, -1})) == "M" && at(map_grid, move(pos, {-1, 1})) == "S")
  end

  defp move({posx, posy}, {dirx, diry}) do
    {posx + dirx, posy + diry}
  end

  defp at(map_grid, pos) do
    case map_grid do
      %{^pos => c} -> c
      _ -> nil
    end
  end

  defp map_grid(lines) do
    lines
    |> Enum.with_index
    |> Enum.flat_map(fn {line, row} ->
      String.graphemes(line)
      |> Enum.with_index
      |> Enum.flat_map(fn {char, col} ->
        position = {row, col}
        [{position, char}]
      end)
    end)
    |> Map.new
  end
end
