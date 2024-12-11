defmodule AdventOfCode.Solution.Year2024.Day09 do
  def part1(input) do
    # input =
    #   "2333133121414131402"

    input =
      parse_input(input)
      |> IO.inspect()

    finished_length = input |> Enum.take_every(2) |> IO.inspect() |> Enum.sum()

    list =
      input
      # |> Enum.reduce({0, true, []}, fn num, {file_id, fill?, list} ->
      #   fill_value = if fill?, do: file_id, else: nil
      #   next_file_id = if fill?, do: file_id + 1, else: file_id
      #   list = if num == 0, do: list, else: [for(_i <- 1..num, do: fill_value) | list]
      #   {next_file_id, !fill?, list}
      # end)
      # |> elem(2)
      # |> Enum.reverse()
      # |> List.flatten()
      #
      |> Enum.chunk_every(2)
      |> Enum.with_index()
      |> Enum.map(fn {part, idx} ->
        case part do
          [block, space] ->
            block_str = String.duplicate("#{idx}", block)
            space_str = String.duplicate(".", space)
            "#{block_str}#{space_str}"

          [block] ->
            String.duplicate("#{idx}", block)
        end
      end)
      |> Enum.join()
      |> IO.inspect()

    backfills = Enum.reject(list, &(!&1)) |> Enum.reverse() |> IO.inspect()

    list
    |> Enum.reduce_while({0, [], backfills}, fn num, {length, built, list} ->
      if length == finished_length do
        {:halt, Enum.reverse(built)}
      else
        if num do
          {:cont, {length + 1, [num | built], list}}
        else
          {:cont, {length + 1, [hd(list) | built], tl(list)}}
        end
      end
    end)
    |> IO.inspect()
    |> Enum.reduce({0, 0}, fn num, {idx, acc} ->
      {idx + 1, acc + idx * num}
    end)
    |> elem(1)

    # |> String.graphemes()

    # |> IO.inspect()

    # switch_dots(disk, [], [])
    # |> Enum.reject(fn c -> c == "." end)
    # |> Enum.map(&String.to_integer/1)
    # |> Enum.with_index()
    # |> Enum.reduce(0, fn {n, idx}, acc -> acc + n * idx end)
  end

  def part2(_input) do
  end

  defp switch_dots([], trailing_dots, result) do
    result ++ trailing_dots
  end

  defp switch_dots(["." | rest], trailing_dots, result) do
    {last_e, rest} = List.pop_at(rest, -1)

    case last_e do
      "." ->
        switch_dots(["." | rest], ["." | trailing_dots], result)

      n ->
        switch_dots(rest, ["." | trailing_dots], result ++ [n])
    end
  end

  defp switch_dots([n | rest], trailing_dots, result) do
    switch_dots(rest, trailing_dots, result ++ [n])
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.to_integer()
    |> Integer.digits()
  end
end
