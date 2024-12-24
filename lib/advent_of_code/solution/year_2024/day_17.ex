defmodule AdventOfCode.Solution.Year2024.Day17 do
  def part1(input) do
    {reg, ins, _program} = parse_input(input)
    ins_ptr = 0

    {_reg, output} = perform(ins_ptr, ins, reg, [])

    Enum.join(output, ",")
  end

  def part2(input) do
    {_reg, ins, program} = parse_input(input)
    ins_ptr = 0

    0..100_000_000
    |> Enum.reduce_while(0, fn n, _reg_a ->
      {_reg, output} = perform(ins_ptr, ins, {n, 0, 0}, [])

      if Enum.join(output, ",") == program do
        {:halt, n}
      else
        {:cont, n}
      end
    end)
  end

  defp perform(ins_ptr, instructions, reg = {a, b, c}, output) do
    ins = Map.get(instructions, ins_ptr)
    operand = Map.get(instructions, ins_ptr + 1)

    case operand do
      nil ->
        {reg, output}

      _ ->
        case ins do
          0 ->
            a = trunc(a / :math.pow(2, combo_operands_value(operand, reg)))
            perform(ins_ptr + 2, instructions, {a, b, c}, output)

          1 ->
            perform(
              ins_ptr + 2,
              instructions,
              {a, Bitwise.bxor(b, operand), c},
              output
            )

          2 ->
            perform(
              ins_ptr + 2,
              instructions,
              {a, rem(combo_operands_value(operand, reg), 8), c},
              output
            )

          3 ->
            ins_ptr = if a == 0, do: ins_ptr + 2, else: operand
            perform(ins_ptr, instructions, reg, output)

          4 ->
            perform(
              ins_ptr + 2,
              instructions,
              {a, Bitwise.bxor(b, c), c},
              output
            )

          5 ->
            out = rem(combo_operands_value(operand, reg), 8)

            perform(
              ins_ptr + 2,
              instructions,
              {a, b, c},
              output ++ [out]
            )

          6 ->
            b = trunc(a / :math.pow(2, combo_operands_value(operand, reg)))
            perform(ins_ptr + 2, instructions, {a, b, c}, output)

          7 ->
            c = trunc(a / :math.pow(2, combo_operands_value(operand, reg)))
            perform(ins_ptr + 2, instructions, {a, b, c}, output)
        end
    end
  end

  defp combo_operands_value(7, _reg), do: :invalid_operand
  defp combo_operands_value(op, _reg) when op in [0, 1, 2, 3], do: op
  defp combo_operands_value(4, {a, _b, _c}), do: a
  defp combo_operands_value(5, {_a, b, _c}), do: b
  defp combo_operands_value(6, {_a, _b, c}), do: c

  # def init_cache do
  #   if :ets.whereis(:day_17_2024_cache) != :undefined do
  #     :ets.delete(:day_17_2024_cache)
  #   end
  #
  #   :ets.new(:day_17_2024_cache, [:set, :public, :named_table])
  # end

  # Register A: 729
  # Register B: 0
  # Register C: 0
  #
  # Program: 0,1,5,4,3,0
  defp parse_input(input) do
    [regA, regB, regC, program] = String.split(input, "\n", trim: true)

    "Register A: " <> valA = regA
    "Register B: " <> valB = regB
    "Register C: " <> valC = regC
    "Program: " <> operands = program

    {
      {String.to_integer(valA), String.to_integer(valB), String.to_integer(valC)},
      operands
      |> String.split(",", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(Map.new(), fn {ins, idx}, acc ->
        Map.put(acc, idx, String.to_integer(ins))
      end),
      operands
    }
  end
end
