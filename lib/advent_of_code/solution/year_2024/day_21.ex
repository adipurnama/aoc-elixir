defmodule AdventOfCode.Solution.Year2024.Day21 do
  def part1(input) do
    numeric_grid = numeric_keypad_layout()
    keypad_grid = directional_keypad_layout()

    keypress =
      parse(input)
      |> Enum.map(fn code ->
        keypad_press(numeric_grid, code, 1)
      end)
      |> Enum.reduce([], fn robot_press, robot2_press ->
        lv2_press = keypad_press(keypad_grid, robot_press, 2)
        robot2_press ++ [lv2_press]
      end)

    num_parts =
      parse(input)
      # |> Enum.take(1)
      |> Enum.map(&parse_numeric/1)

    Enum.zip(keypress, num_parts)
    |> Enum.reduce(0, fn {kp, nd}, acc ->
      IO.inspect(kp)
      IO.inspect(String.length(kp))
      IO.inspect(nd)
      acc + String.length(kp) * nd
    end)
  end

  def part2(_input) do
  end

  defp numeric_keypad_layout() do
    input = """
    789
    456
    123
    #0A
    """

    AdventOfCode.PathGrid.new(input)
  end

  defp directional_keypad_layout() do
    input = """
    #^A
    <v>
    """

    AdventOfCode.PathGrid.new(input)
  end

  defp keypad_press(_keypad_grid, input, 0), do: input

  defp keypad_press(keypad_grid, input, depth) do
    IO.inspect(input, label: "input")

    new_input =
      input
      |> String.graphemes()
      |> Enum.reduce({"", "A"}, fn ch, {paths, ptr_ch} ->
        from = btn_pos(keypad_grid, ptr_ch)
        to = btn_pos(keypad_grid, ch)

        if from == to do
          {paths <> "A", ch}
        else
          selected_path =
            shortest_path(keypad_grid.graph, from, to) |> tap(&IO.inspect(&1, label: "selected"))

          {paths <> selected_path <> "A", ch}
        end
      end)
      |> elem(0)

    keypad_press(keypad_grid, new_input, depth - 1)
  end

  defp shortest_path(graph, from, to) do
    paths =
      Graph.get_paths(graph, from, to)
      |> Enum.sort(fn l1, l2 -> length(l1) < length(l2) end)

    paths
    |> Enum.reduce_while({nil, nil}, fn l, {path, length} ->
      if length != nil and length < length(l) do
        {:halt, {path, length}}
      else
        movement =
          l
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [pos_from, pos_to] -> movement(pos_from, pos_to) end)
          |> Enum.join()

        case path do
          nil ->
            {:cont, {movement, length(l)}}

          path ->
            selected =
              if character_sequence_count(movement) > character_sequence_count(path),
                do: movement,
                else: path

            {:cont, {selected, length(l)}}
        end
      end
    end)
    |> elem(0)
  end

  defp character_sequence_count(string) do
    {map, _, _} =
      string
      |> String.graphemes()
      |> Enum.reduce({%{}, "", 0}, fn ch, {acc, prev_ch, ch_count} ->
        prev_count = Map.get(acc, prev_ch, 0)
        new_count = if prev_ch != ch, do: 0, else: ch_count + 1
        acc = if new_count > prev_count, do: Map.put(acc, prev_ch, new_count), else: acc

        {acc, ch, new_count}
      end)

    map
    |> Enum.reduce(0, fn {_ch, max}, cur_max ->
      if max > cur_max, do: max, else: cur_max
    end)
  end

  defp movement({x1, y1}, {x2, y2}) do
    case {x2 - x1, y2 - y1} do
      {0, 1} -> "v"
      {1, 0} -> ">"
      {-1, 0} -> "<"
      {0, -1} -> "^"
    end
  end

  defp btn_pos(grid, ch) do
    Enum.find(grid.units, &(&1.identifier == ch)) |> Map.get(:position)
  end

  defp parse_numeric(row) do
    String.replace(row, ~r/[^0-9]/, "")
    |> String.to_integer()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
  end
end

defmodule AdventOfCode.Solution.Year2024.Day21 do
  def part1(input) do
    numeric_grid = numeric_keypad_layout()
    keypad_grid = directional_keypad_layout()

    keypress =
      parse(input)
      |> Enum.map(fn code ->
        keypad_press(numeric_grid, code, 1)
      end)
      |> Enum.reduce([], fn robot_press, robot2_press ->
        lv2_press = keypad_press(keypad_grid, robot_press, 2)
        robot2_press ++ [lv2_press]
      end)

    num_parts =
      parse(input)
      # |> Enum.take(1)
      |> Enum.map(&parse_numeric/1)

    Enum.zip(keypress, num_parts)
    |> Enum.reduce(0, fn {kp, nd}, acc ->
      IO.inspect(kp)
      IO.inspect(String.length(kp))
      IO.inspect(nd)
      acc + String.length(kp) * nd
    end)
  end

  def part2(_input) do
  end

  defp numeric_keypad_layout() do
    input = """
    789
    456
    123
    #0A
    """

    AdventOfCode.PathGrid.new(input)
  end

  defp directional_keypad_layout() do
    input = """
    #^A
    <v>
    """

    AdventOfCode.PathGrid.new(input)
  end

  defp keypad_press(_keypad_grid, input, 0), do: input

  defp keypad_press(keypad_grid, input, depth) do
    IO.inspect(input, label: "input")

    new_input =
      input
      |> String.graphemes()
      |> Enum.reduce({"", "A"}, fn ch, {paths, ptr_ch} ->
        from = btn_pos(keypad_grid, ptr_ch)
        to = btn_pos(keypad_grid, ch)

        if from == to do
          {paths <> "A", ch}
        else
          selected_path =
            shortest_path(keypad_grid.graph, from, to) |> tap(&IO.inspect(&1, label: "selected"))

          {paths <> selected_path <> "A", ch}
        end
      end)
      |> elem(0)

    keypad_press(keypad_grid, new_input, depth - 1)
  end

  defp shortest_path(graph, from, to) do
    paths =
      Graph.get_paths(graph, from, to)
      |> Enum.sort(fn l1, l2 -> length(l1) < length(l2) end)

    paths
    |> Enum.reduce_while({nil, nil}, fn l, {path, length} ->
      if length != nil and length < length(l) do
        {:halt, {path, length}}
      else
        movement =
          l
          |> Enum.chunk_every(2, 1, :discard)
          |> Enum.map(fn [pos_from, pos_to] -> movement(pos_from, pos_to) end)
          |> Enum.join()

        case path do
          nil ->
            {:cont, {movement, length(l)}}

          path ->
            selected =
              if character_sequence_count(movement) > character_sequence_count(path),
                do: movement,
                else: path

            {:cont, {selected, length(l)}}
        end
      end
    end)
    |> elem(0)
  end

  defp character_sequence_count(string) do
    {map, _, _} =
      string
      |> String.graphemes()
      |> Enum.reduce({%{}, "", 0}, fn ch, {acc, prev_ch, ch_count} ->
        prev_count = Map.get(acc, prev_ch, 0)
        new_count = if prev_ch != ch, do: 0, else: ch_count + 1
        acc = if new_count > prev_count, do: Map.put(acc, prev_ch, new_count), else: acc

        {acc, ch, new_count}
      end)

    map
    |> Enum.reduce(0, fn {_ch, max}, cur_max ->
      if max > cur_max, do: max, else: cur_max
    end)
  end

  defp movement({x1, y1}, {x2, y2}) do
    case {x2 - x1, y2 - y1} do
      {0, 1} -> "v"
      {1, 0} -> ">"
      {-1, 0} -> "<"
      {0, -1} -> "^"
    end
  end

  defp btn_pos(grid, ch) do
    Enum.find(grid.units, &(&1.identifier == ch)) |> Map.get(:position)
  end

  defp parse_numeric(row) do
    String.replace(row, ~r/[^0-9]/, "")
    |> String.to_integer()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
  end
end
