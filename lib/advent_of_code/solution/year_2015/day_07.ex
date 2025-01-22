defmodule AdventOfCode.Solution.Year2015.Day07 do
  import Bitwise

  def part1(input) do
    gates = parse_gates(input)

    wires =
      gates
      |> Enum.reduce(%{}, fn {wire, _opr}, acc -> Map.put(acc, wire, wire_value(gates, wire)) end)

    Map.get(wires, "a")
  end

  def part2(input) do
    gates = parse_gates(input)

    wires =
      gates
      |> Enum.reduce(%{}, fn {wire, _opr}, acc -> Map.put(acc, wire, wire_value(gates, wire)) end)

    gates = Map.put(gates, "b", Map.get(wires, "a"))

    # delete previous memo cache
    gates
    |> Enum.each(fn {wire, _val} -> Process.delete(wire) end)

    wires =
      gates
      |> Enum.reduce(%{}, fn {wire, _opr}, acc -> Map.put(acc, wire, wire_value(gates, wire)) end)

    Map.get(wires, "a")
  end

  defp wire_value(gates, wire) do
    with nil <- Process.get(wire) do
      case Map.get(gates, wire) do
        {opr, op1} ->
          v = if is_number(op1), do: op1, else: wire_value(gates, op1)
          opr.(v)

        {opr, op1, op2} ->
          v1 = if is_number(op1), do: op1, else: wire_value(gates, op1)
          v2 = if is_number(op2), do: op2, else: wire_value(gates, op2)

          opr.(v1, v2)

        n ->
          if is_number(n), do: n, else: wire_value(gates, n)
      end
      |> tap(fn result ->
        Process.put(wire, result)
      end)
    end
  end

  defp parse_gates(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(&parse_gate/1)
    |> Enum.reduce(%{}, fn {wire, val}, acc ->
      Map.put(acc, wire, val)
    end)
  end

  defp parse_gate(line) do
    case String.split(line, " ", trim: true) do
      [w1, "->", wire] ->
        {wire, wire_or_number(w1)}

      [w1, "AND", w2, "->", wire] ->
        {wire, {&Bitwise.band/2, wire_or_number(w1), wire_or_number(w2)}}

      [w1, "OR", w2, "->", wire] ->
        {wire, {&Bitwise.bor/2, wire_or_number(w1), wire_or_number(w2)}}

      [w1, "LSHIFT", w2, "->", wire] ->
        {wire, {&Bitwise.bsl/2, wire_or_number(w1), wire_or_number(w2)}}

      [w1, "RSHIFT", w2, "->", wire] ->
        {wire, {&Bitwise.bsr/2, wire_or_number(w1), wire_or_number(w2)}}

      ["NOT", w1, "->", wire] ->
        {wire, {&bnot_complement/1, wire_or_number(w1)}}
    end
  end

  defp bnot_complement(number) do
    # Mask to 16 bits
    Bitwise.bnot(number) &&& 0xFFFF
  end

  defp wire_or_number(w) do
    case Integer.parse(w) do
      {num, ""} -> num
      _ -> w
    end
  end
end
