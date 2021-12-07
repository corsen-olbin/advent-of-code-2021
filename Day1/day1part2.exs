defmodule AOCDay1 do
  def find_num_of_increase_over_3(body) do
    body
    |> String.split
    |> Enum.map(&(String.to_integer(&1)))
    |> check_all_increase_or_decrease
    |> count_increases
    |> print_answer
  end

  def check_all_increase_or_decrease([first, second, third | tail]) do
    check_all_increase_or_decrease_rec(tail, nil, first, second, third, [])
  end

  def check_all_increase_or_decrease_rec([], first, second, third, fourth, acc) do
    [increase_or_decrease(first, second, third, fourth) | acc]
  end

  def check_all_increase_or_decrease_rec([head | tail], first, second, third, fourth, acc) do
    new_acc = [increase_or_decrease(first, second, third, fourth) | acc]
    check_all_increase_or_decrease_rec(tail, second, third, fourth, head, new_acc)
  end

  def increase_or_decrease(nil, _, _, _), do: :no_previous

  def increase_or_decrease(first, second, third, fourth) do
    first_sum = first + second + third
    second_sum = second + third + fourth
    cond do
      first_sum > second_sum -> :decrease
      first_sum < second_sum -> :increase
      true -> :no_change
    end
  end

  def count_increases(list), do: Enum.count(list, &(&1 == :increase))

  def print_answer(answer), do: IO.puts("Num of increases: #{answer}")
end

case File.read("./AdventOfCodeDay1Values.txt") do
  {:ok, body}      -> AOCDay1.find_num_of_increase_over_3(body)
  {:error, reason} -> IO.puts(reason)
end
