defmodule AOCDay1 do
  def find_num_of_increase(body) do
    body
    |> String.split
    |> Enum.map(&(String.to_integer(&1)))
    |> check_all_increase_or_decrease
    |> count_increases
    |> print_answer
  end

  def check_all_increase_or_decrease([head | tail]) do
    check_all_increase_or_decrease_rec(tail, nil, head, [])
  end

  def check_all_increase_or_decrease_rec([], first, second, acc), do: [increase_or_decrease(first, second) | acc]
  def check_all_increase_or_decrease_rec([head | tail], first, second, acc) do
    check_all_increase_or_decrease_rec(tail, second, head, [increase_or_decrease(first, second) | acc])
  end

  def increase_or_decrease(nil, _), do: :no_previous
  def increase_or_decrease(first, second) when first > second, do: :decrease
  def increase_or_decrease(first, second) when first < second, do: :increase

  def count_increases(list), do: Enum.count(list, &(&1 == :increase))

  def print_answer(answer), do: IO.puts("Num of increases: #{answer}")
end

case File.read("./AdventOfCodeDay1Values.txt") do
  {:ok, body}      -> AOCDay1.find_num_of_increase(body)
  {:error, reason} -> IO.puts(reason)
end
