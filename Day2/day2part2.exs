defmodule AOCDay2 do
  def find_product_depth_and_horizontal(body) do
    body
    |> String.split("\n")
    |> calculate_depth_and_distance
    |> print_answer
  end

  def split_direction_and_number(combo) do
    [command, number] = String.split(combo)
    {command, String.to_integer(number)}
  end

  def calculate_depth_and_distance(list) do
    calculate_depth_and_distance_rec(list, {0, 0, 0})
  end

  def calculate_depth_and_distance_rec([], acc), do: acc
  def calculate_depth_and_distance_rec([head | tail], acc) do
    new_acc = calc_new_depth_and_distance(split_direction_and_number(head), acc)
    calculate_depth_and_distance_rec(tail, new_acc)
  end

  def calc_new_depth_and_distance({"forward", num}, {horizontal, depth, aim}), do: {horizontal + num, depth + (aim * num), aim}
  def calc_new_depth_and_distance({"down", num}, {horizontal, depth, aim}), do: {horizontal, depth, aim + num}
  def calc_new_depth_and_distance({"up", num}, {horizontal, depth, aim}), do: {horizontal, depth, aim - num}

  def print_answer({horizontal, depth, _}), do: IO.puts("Product of horizontal distance and depth: #{horizontal * depth}")
end

case File.read("./AdventOfCodeDay2Values.txt") do
  {:ok, body}      -> AOCDay2.find_product_depth_and_horizontal(body)
  {:error, reason} -> IO.puts(reason)
end
