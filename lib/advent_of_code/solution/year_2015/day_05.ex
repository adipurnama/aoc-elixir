defmodule AdventOfCode.Solution.Year2015.Day05 do
  defmodule Part1 do
    # Three or more vowels
    @vowels_regex ~r/[aeiou].*[aeiou].*[aeiou]/

    # At least one letter appearing twice in a row
    @double_letter_regex ~r/(.)\1/

    # Forbidden strings
    @forbidden_pairs_regex ~r/ab|cd|pq|xy/

    def nice_string?(str) do
      has_three_vowels?(str) and
        has_double_letter?(str) and
        not has_forbidden_pairs?(str)
    end

    # Helper functions for each rule
    defp has_three_vowels?(str) do
      String.match?(str, @vowels_regex)
    end

    defp has_double_letter?(str) do
      String.match?(str, @double_letter_regex)
    end

    defp has_forbidden_pairs?(str) do
      String.match?(str, @forbidden_pairs_regex)
    end
  end

  defmodule Part2 do
    # Pair of letters that appears twice without overlapping
    @repeating_pair_regex ~r/(..).*\1/

    # Letter that repeats with exactly one letter between
    @letter_sandwich_regex ~r/(.).\1/

    def nice_string?(str) do
      has_repeating_pair?(str) and has_letter_sandwich?(str)
    end

    defp has_repeating_pair?(str) do
      String.match?(str, @repeating_pair_regex)
    end

    defp has_letter_sandwich?(str) do
      String.match?(str, @letter_sandwich_regex)
    end
  end

  def part1(input) do
    nice_string_count(input, &Part1.nice_string?/1)
  end

  def part2(input) do
    nice_string_count(input, &Part2.nice_string?/1)
  end

  defp nice_string_count(input, evaluator) do
    input
    |> String.split("\n", trim: true)
    |> Enum.filter(evaluator)
    |> Enum.count()
  end
end
