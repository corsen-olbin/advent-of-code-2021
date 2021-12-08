defmodule AOCDay3 do
  def find_sub_power_consumption(input) do
    list = String.split(input)
    compare_most_common = fn x ->
      case x do
        :ones -> "1"
        :even -> "1"
        :zeros -> "0"
      end
    end

    compare_least_common = fn x ->
      case x do
        :ones -> "0"
        :even -> "0"
        :zeros -> "1"
      end
    end

    oxygen_binary = find_rating(list, compare_most_common)
    co2_binary = find_rating(list, compare_least_common)
    { oxygen_rating, _} = Integer.parse(oxygen_binary, 2)
    { co2_rating, _} = Integer.parse(co2_binary, 2)
    IO.puts("oxygen: #{oxygen_rating} co2: #{co2_rating}")
    IO.puts("final rating: #{oxygen_rating * co2_rating}")
  end

  def find_rating(list, compare_func) do
    find_rating_rec(list, 0, compare_func)
  end

  def find_rating_rec([head], _, _), do: head
  def find_rating_rec(list, pos, compare_func) do
    more_of = find_more_ones_or_zeros(list, pos)
    to_compare = compare_func.(more_of)

    filtered =
      list
      |> Enum.filter(fn x -> String.at(x, pos) == to_compare end)

    find_rating_rec(filtered, pos + 1, compare_func)

  end

  def find_more_ones_or_zeros(list, pos) do
    count = Enum.count(list)

    ones_total = Enum.count(list, fn x -> String.at(x, pos) == "1" end)
    half = count / 2

    cond do
      ones_total < half -> :zeros
      ones_total == half -> :even
      ones_total > half -> :ones
    end
  end

  def print_answer({gamma, epsilon}), do: IO.puts("Power consumption: #{gamma * epsilon}")
end

case File.read("./day3values.txt") do
  {:ok, body} -> AOCDay3.find_sub_power_consumption(body)
  {:error, reason} -> IO.puts(reason)
end

#937
#3154
