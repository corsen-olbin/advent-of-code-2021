defmodule AOCDay9 do
  def find_sum_3_largest_basins(body) do
    body
    |> String.split()
    |> turn_grid_into_map()
    |> find_basin_sizes()
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.reduce(fn x, acc -> acc * x end)
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

  def find_basin_sizes(map) do
    for i <- 0..Enum.count(map),
        j <- 0..Enum.count(map[0]),
        low_point?(map, i, j),
        do: find_basin_size(map, i, j)
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

  def find_basin_size(map, i, j) do
    find_basin_points_rec(map, i, j)
    |> Enum.uniq()
    |> Enum.count()
  end

  def find_basin_points_rec(map, i, j) do
    point = map[i][j]
    left = map |> Map.get(i, %{}) |> Map.get(j - 1, 10)
    right = map |> Map.get(i, %{}) |> Map.get(j + 1, 10)
    above = map |> Map.get(i - 1, %{}) |> Map.get(j, 10)
    below = map |> Map.get(i + 1, %{}) |> Map.get(j, 10)

    left_acc =
      if point < left do
        find_basin_points_rec(map, i, j - 1)
      else
        []
      end

    right_acc =
      if point < right do
        find_basin_points_rec(map, i, j + 1)
      else
        []
      end

    above_acc =
      if point < above do
        find_basin_points_rec(map, i - 1, j)
      else
        []
      end

    below_acc =
      if point < below do
        find_basin_points_rec(map, i + 1, j)
      else
        []
      end

      if point >= 9 do
        []
      else
        [{i, j}] ++ left_acc ++ right_acc ++ above_acc ++ below_acc
      end
  end

  def print_answer(answer) do
    IO.puts("product of top 3 basin sizes: #{answer}")
  end
end

case File.read("./day9values.txt") do
  {:ok, body} -> AOCDay9.find_sum_3_largest_basins(body)
  {:error, reason} -> IO.puts(reason)
end
