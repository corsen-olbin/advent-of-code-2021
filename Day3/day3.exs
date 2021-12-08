defmodule AOCDay3 do

  def find_sub_power_consumption(input) do
    input
    |> String.split()
    |> reduce_to_ones_totals
    |> convert_to_epsilon_gamma
    |> print_answer
  end

  def reduce_to_ones_totals(list) do
    count = Enum.count(list)
    length_of_single = list |> List.first() |> String.length()
    acc_start = List.duplicate(0, length_of_single)
    ones_totals = Enum.reduce(list, acc_start, fn elem, acc -> add_1s_to_acc(elem, acc) end)
    {count, ones_totals}
  end

  def add_1s_to_acc(elem, acc) do
    elem_array = String.split(elem, "", trim: true) |> Enum.map(&String.to_integer(&1))
    Enum.zip_with(elem_array, acc, fn e1, e2 -> e1 + e2 end)
  end

  def convert_to_epsilon_gamma({count, ones_totals}) do
    gamma_bitstring =
      Enum.map(ones_totals, fn x ->
        if x > count / 2 do
          1
        else
          0
        end
      end)
      |> Enum.into(<<>>, fn bit -> <<bit::1>> end)

    epsilon_bitstring =
      for <<a::1 <- gamma_bitstring>>,
        into: <<>>,
        do:
          (if a == 1 do
             <<0::1>>
           else
             <<1::1>>
           end)

    <<gamma_rate::32>> = <<(<<0::20>>), gamma_bitstring::bitstring>>
    <<epsilon_rate::32>> = <<(<<0::20>>), epsilon_bitstring::bitstring>>

    {gamma_rate, epsilon_rate}
  end

  def print_answer({gamma, epsilon}), do: IO.puts("Power consumption: #{gamma * epsilon}")
end

case File.read("./day3values.txt") do
  {:ok, body} -> AOCDay3.find_sub_power_consumption(body)
  {:error, reason} -> IO.puts(reason)
end
