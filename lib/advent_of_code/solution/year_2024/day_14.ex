defmodule AdventOfCode.Solution.Year2024.Day14 do
  def part1(input) do
    # input = """
    # p=2,4 v=2,-3
    # """

    robots =
      input
      |> parse()

    {max_x, max_y} = grid_size(robots)

    quadrants = make_quadrant({max_x, max_y})

    1..100
    |> Enum.reduce(robots, fn _, nrobots ->
      turn(nrobots, {max_x, max_y})
    end)
    |> Enum.reduce([0, 0, 0, 0], fn {{x, y}, _}, [q1, q2, q3, q4] ->
      [in_q1, in_q2, in_q3, in_q4] =
        quadrants
        |> Enum.map(fn q -> if in_quadrant?({x, y}, q), do: 1, else: 0 end)

      [q1 + in_q1, q2 + in_q2, q3 + in_q3, q4 + in_q4]
    end)
    |> Enum.reduce(1, fn n, acc -> n * acc end)
  end

  def part2(input) do
    robots =
      input
      |> parse()

    {max_x, max_y} = grid_size(robots)

    # Count up until you see a treeeeee!?!?!?
    trees =
      [
        "1111111111111111111111111111111",
        "1                             1",
        "1                             1",
        "1                             1",
        "1                             1",
        "1              1              1",
        "1             111             1",
        "1            11111            1",
        "1           1111111           1",
        "1          111111111          1",
        "1            11111            1",
        "1           1111111           1",
        "1          111111111          1",
        "1         11111111111         1",
        "1        1111111111111        1",
        "1          111111111          1",
        "1         11111111111         1",
        "1        1111111111111        1",
        "1       111111111111111       1",
        "1      11111111111111111      1",
        "1        1111111111111        1",
        "1       111111111111111       1",
        "1      11111111111111111      1",
        "1     1111111111111111111     1",
        "1    111111111111111111111    1",
        "1             111             1",
        "1             111             1",
        "1             111             1",
        "1                             1",
        "1                             1",
        "1                             1",
        "1                             1",
        "1111111111111111111111111111111"
      ]

    # trees
    # |> Enum.each(&IO.inspect/1)

    # map_grid =
    #   robots
    #   |> Enum.reduce(%{}, fn {pos, _}, acc -> Map.put(acc, pos, "X") end)
    #
    # printed_map_grid =
    #   print_grid(map_grid, max_x, max_y)
    #
    #
    # printed_map_grid
    # |> Enum.each(&IO.inspect/1)

    n = 1_000_000

    0..n
    |> Enum.reduce_while(robots, fn i, nrobots ->
      nrobots = turn(nrobots, {max_x, max_y})

      map_grid =
        nrobots
        |> Enum.reduce(%{}, fn {pos, _}, acc -> Map.put(acc, pos, "1") end)

      printed_map_grid =
        print_grid(map_grid, max_x, max_y)

      if tree_found?(printed_map_grid, trees) do
        IO.inspect(i)
        IO.inspect(printed_map_grid)
        {:halt, nrobots}
      else
        {:cont, nrobots}
      end
    end)
  end

  defp tree_found?(map_grid, trees) do
    {found_idx, _} =
      map_grid
      |> Enum.with_index()
      |> Enum.reduce_while({nil, 0}, fn {row, idx}, {cur_found_idx, check_idx} ->
        case :binary.match(row, "11111") do
          {found_idx, _} ->
            {:halt, {found_idx, check_idx + 1}}

          # if cur_found_idx != found_idx do
          #   {:cont, {nil, 0}}
          # else
          #   {:cont, {found_idx, check_idx + 1}}
          # end

          :nomatch ->
            cond do
              check_idx == length(trees) ->
                {:halt, {cur_found_idx, check_idx}}

              idx > length(map_grid) - length(trees) + 1 ->
                {:cont, {nil, 0}}

              true ->
                {:halt, {nil, check_idx}}
            end
        end
      end)

    found_idx != nil
  end

  defp print_grid(grid, w, h) do
    0..h
    |> Enum.reduce([], fn y, rows ->
      y_row =
        0..w
        |> Enum.reduce([], fn x, xy ->
          xy ++ [Map.get(grid, {x, y}, "-")]
        end)
        |> Enum.join()

      rows ++ [y_row]
    end)
  end

  defp grid_size(robots) do
    {max_x, max_y} =
      robots
      |> Enum.reduce({0, 0}, fn {{x, y}, _}, {max_x, max_y} ->
        if x > max_x do
          if y > max_y, do: {x, y}, else: {x, max_y}
        else
          if y > max_y, do: {max_x, y}, else: {max_x, max_y}
        end
      end)

    {max_x, max_y}
  end

  defp in_quadrant?({x, y}, {{x1, y1}, {x2, y2}}) do
    x1 <= x && x <= x2 && y1 <= y && y <= y2
  end

  defp make_quadrant({max_x, max_y}) do
    centerx = max_x / 2
    centery = max_y / 2

    [
      {{0, 0}, {centerx - 1, centery - 1}},
      {{centerx + 1, 0}, {max_x, centery - 1}},
      {{0, centery + 1}, {centerx - 1, max_y}},
      {{centerx + 1, centery + 1}, {max_x, max_y}}
    ]
  end

  defp turn(robots, {max_x, max_y}) do
    robots
    |> Enum.map(fn {pos, vxy} ->
      new_pos = move(pos, vxy, {max_x, max_y})
      {new_pos, vxy}
    end)
  end

  defp move({x, y}, {vx, vy}, {max_x, max_y}) do
    {new_pos(x, vx, max_x), new_pos(y, vy, max_y)}
  end

  defp new_pos(d, vd, max_d) do
    new_d = d + vd

    cond do
      new_d > max_d ->
        new_d - max_d - 1

      new_d < 0 ->
        max_d + new_d + 1

      true ->
        new_d
    end
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    # p=0,4 v=3,-3
    [[_, x, y, vx, vy]] =
      Regex.scan(~r/p\=(-?\d{1,3}),(-?\d{1,3}) v\=(-?\d{1,3}),(-?\d{1,3})/, line)

    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(vx), String.to_integer(vy)}}
  end
end
