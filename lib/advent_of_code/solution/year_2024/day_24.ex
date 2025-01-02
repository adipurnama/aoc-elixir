defmodule AdventOfCode.Solution.Year2024.Day24 do
  def part1(input) do
    {inputs, gates} = parse(input)

    gates
    |> Enum.filter(&String.starts_with?(elem(&1, 0), "z"))
    |> Enum.sort_by(&elem(&1, 0), :desc)
    |> Stream.map(fn {wire, _} ->
      if wire_value(inputs, gates, wire), do: "1", else: "0"
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def part2(_input) do
  end

  defp wire_value(inputs, gates, wire) do
    with nil <- Process.get(wire) do
      case Map.get(inputs, wire) do
        nil ->
          {gate_fn, [input1, input2]} = Map.get(gates, wire)
          gate_fn.(wire_value(inputs, gates, input1), wire_value(inputs, gates, input2))

        val ->
          val
      end
      |> tap(&Process.put(wire, &1))
    end
  end

  defp xor(input1, input2), do: input1 != input2

  defp parse(input) do
    [inputs, gates] = String.split(input, "\n\n", trim: true)

    inputs =
      inputs
      |> String.split("\n", trim: true)
      |> Enum.reduce(Map.new(), fn line, acc ->
        [key, val] = String.split(line, ": ", trim: true)
        val = if val == "1", do: true, else: false
        Map.put(acc, key, val)
      end)

    gates =
      gates
      |> String.split("\n", trim: true)
      |> Enum.reduce(Map.new(), fn line, acc ->
        [input1, opr, input2, _arrow, val] = String.split(line, " ", trim: true)

        opr =
          case opr do
            "AND" -> &and/2
            "OR" -> &or/2
            "XOR" -> &xor/2
          end

        Map.put(acc, val, {opr, [input1, input2]})
      end)

    {inputs, gates}
  end
end
