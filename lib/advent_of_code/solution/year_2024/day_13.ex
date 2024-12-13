defmodule AdventOfCode.Solution.Year2024.Day13 do
  def part1(input) do
    parse(input)
    |> Enum.map(&solve/1)
    |> Enum.reject(fn sol ->
      case sol do
        {a, b} ->
          a > 100 or b > 100

        nil ->
          true
      end
    end)
    |> Enum.reduce(0, fn {a, b}, acc -> acc + (a * 3 + b) end)
  end

  def part2(input) do
    parse(input)
    |> Enum.map(fn %{a: {ax, ay}, b: {bx, by}, target: {tx, ty}} ->
      %{a: {ax, ay}, b: {bx, by}, target: {tx + 10_000_000_000_000, ty + 10_000_000_000_000}}
    end)
    |> Enum.map(&solve/1)
    |> Enum.reject(&(&1 == nil))
    |> Enum.reduce(0, fn {a, b}, acc -> acc + (a * 3 + b) end)
  end

  defp solve(%{a: {ax, ay}, b: {bx, by}, target: {tx, ty}}) do
    with a <- calculate_a({ax, ay}, {bx, by}, {tx, ty}),
         b <- calculate_b(a, {ax, ay}, {bx, by}, {tx, ty}) do
      if a != nil and b != nil, do: {trunc(a), trunc(b)}, else: nil
    end
  end

  defp calculate_a({ax, ay}, {bx, by}, {tx, ty}) do
    # input = """
    # Button A: X+94, Y+34
    # Button B: X+22, Y+67
    # Prize: X=8400, Y=5400
    # """
    # b = (tx - (a * ax)) / bx
    # (a * ay) + (b * by) = ty
    # b = (ty - (a * ay)) / by
    # (ty - (a * ay)) / by = (tx - (a * ax)) / bx
    # (ty - (a * ay)) * bx = (tx - (a * ax)) * by
    # (ty * bx) - (a * ay * bx) = (tx * by) - (a * ax * by)
    # (ty * bx) - (tx * by) = (a * ay * bx) - (a * ax * by)
    # (ty * bx) - (tx * by) = a * ((ay * bx) - (ax * by))
    # a = ((ty * bx) - (tx * by)) / ((ay * bx) - (ax * by))

    a = (ty * bx - tx * by) / (ay * bx - ax * by)
    if a == Float.round(a), do: a, else: nil
  end

  defp calculate_b(nil, _, _, _), do: nil

  defp calculate_b(a, {ax, _ay}, {bx, _by}, {tx, _ty}) do
    # (a * ax) + (b * bx) = tx
    b = (tx - ax * a) / bx
    if b == Float.round(b), do: b, else: nil
  end

  defp parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(input) do
    cmds =
      input
      |> String.split("\n", trim: true)

    [[_, ax, ay]] = Regex.scan(~r/Button A\: X\+(\d{1,3}), Y\+(\d{1,3})/, Enum.at(cmds, 0))
    [[_, bx, by]] = Regex.scan(~r/Button B\: X\+(\d{1,3}), Y\+(\d{1,3})/, Enum.at(cmds, 1))

    [[_, target_x, target_y]] =
      Regex.scan(~r/Prize\: X\=(\d{1,6}), Y\=(\d{1,6})/, Enum.at(cmds, 2))

    %{
      :a => {String.to_integer(ax), String.to_integer(ay)},
      :b => {String.to_integer(bx), String.to_integer(by)},
      :target => {String.to_integer(target_x), String.to_integer(target_y)}
    }
  end
end
