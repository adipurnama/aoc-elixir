defmodule AdventOfCode.Solution.Year2024.Day05 do
  def part1(input) do
      {cmd_order, cmd} = parse(input)

      cmd
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
      end)
      |> Enum.reject(fn cmd ->
        valid_cmd?(cmd_order, cmd) == false
      end)
      |> sum_middle_element()
  end

  def part2(input) do
      {cmd_order, cmd} = parse(input)

      cmd
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
      end)
      |> Enum.reject(fn cmd ->
        valid_cmd?(cmd_order, cmd)
      end)
      |> Enum.map(&fix_cmd(cmd_order, &1))
      |> sum_middle_element()
  end

  defp parse(input) do
      [order, cmd] =
        input
        |> String.split("\n\n", trim: true)

      cmd_order =
        order
        |> String.split("\n", trim: true)
        |> Enum.map(fn e ->
            [req | [target]] = String.split(e, "|")
            {req, target}
        end)
        |> Enum.reduce(%{}, fn {req, target}, map ->
          Map.update(map, req, [target], fn existing ->
            [target | existing] |> Enum.reverse()
          end)
        end)

      cmd =
        cmd
        |> String.split("\n", trim: true)

      {cmd_order, cmd}
  end

  defp sum_middle_element(cmds) do
    cmds
    |> Enum.reduce(0, fn line, acc ->
        # Calculate the middle index
        middle_index = div(length(line), 2)

        # Get the middle element
        mid = Enum.at(line, middle_index)

        acc + String.to_integer(mid)
      end)
  end

  defp valid_cmd?(cmd_order, cmd) do
    cmd
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce_while(true, fn [a, b], _ok ->
      case Map.get(cmd_order, a) do
        nil ->
          {:halt, false}
        list ->
          if Enum.member?(list, b) do
            {:cont, true}
          else
            {:halt, false}
          end
      end
    end)
  end

  defp fix_cmd(order_cmd, cmd) do
    cmd
    |> Enum.sort(fn a, b ->
      case Map.get(order_cmd, a) do
        nil -> false
        list -> Enum.member?(list, b)
      end
    end)
  end
end
