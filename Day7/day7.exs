defmodule AOCDay7 do
  def find_least_fuel(body) do
    body
    |> String.split(",")
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> calc_least_fuel
    |> print_answer
  end

  def calc_least_fuel([head | _] = list) do
    calc_least_fuel_rec(head, list)
  end

  def calc_least_fuel_rec(position, list) do
    plus1 = calc_fuel(position + 1, list)
    pos = calc_fuel(position, list)
    minus1 = calc_fuel(position - 1, list)

    cond do
      plus1 < pos -> calc_least_fuel_rec(position + 1, list)
      minus1 < pos -> calc_least_fuel_rec(position - 1, list)
      true -> {position, pos}
    end
  end

  def calc_fuel(position, list) do
    list
    |> Enum.map(fn x -> abs(x - position) end)
    |> Enum.sum()
  end

  def print_answer({position, fuel_use}), do: IO.puts("Position: #{position}\r\nLeast fuel used: #{fuel_use}")
end

case File.read("./day7values.txt") do
  {:ok, body}      -> AOCDay7.find_least_fuel(body)
  {:error, reason} -> IO.puts(reason)
end
