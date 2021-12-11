defmodule AOCDay9 do
  def find_sum_low_points(body) do
    body
    |> String.split()
    |> turn_grid_into_map()
    |> find_low_points()
    |> Enum.reduce(0, fn x, acc -> acc + x + 1 end)
    |> print_answer()
  end

  def turn_grid_into_map(lines) do
    lines
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {element, index}, acc ->
      Map.put(acc, index, convert_line(element))
    end)
  end

  def convert_line(line) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {element, index}, acc ->
      Map.put(acc, index, String.to_integer(element))
    end)
  end

  def find_low_points(map) do
    for i <- 0..Enum.count(map), j <- 0..Enum.count(map[0]), low_point?(map, i, j), do: map[i][j]
  end

  def low_point?(map, i, j) do
    point = map[i][j]
    left = map |> Map.get(i, %{}) |> Map.get(j - 1, 10)
    right = map |> Map.get(i, %{}) |> Map.get(j + 1, 10)
    above = map |> Map.get(i - 1, %{}) |> Map.get(j, 10)
    below = map |> Map.get(i + 1, %{}) |> Map.get(j, 10)

    point < left and
    point < right and
    point < above and
    point < below
  end

  def print_answer(answer) do
    IO.puts("sum of all risk levels: #{answer}")
  end
end

case File.read("./day9values.txt") do
  {:ok, body} -> AOCDay9.find_sum_low_points(body)
  {:error, reason} -> IO.puts(reason)
end
