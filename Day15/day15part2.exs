defmodule AOCDay15 do
  @expansion [
    [0, 1, 2, 3, 4],
    [1, 2, 3, 4, 5],
    [2, 3, 4, 5, 6],
    [3, 4, 5, 6, 7],
    [4, 5, 6, 7, 8]
  ]

  def find_least_risky_path(body) do
    body
    |> String.split()
    |> turn_grid_into_map()
    |> expand_map()
    |> dijkstra()
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

  def expand_map(map) do
    x_max = Enum.count(map)
    y_max = Enum.count(map[0])

    @expansion
    |> Enum.with_index()
    |> Enum.reduce(map, fn {ey_list, ex}, acc ->
      ey_list
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {increase, ey}, acc2 ->
        for i <- 0..(x_max - 1), j <- 0..(y_max - 1), reduce: acc2 do
          acc3 ->
            map_2d_update(
              acc3,
              ex * x_max + i,
              ey * y_max + j,
              rem(map[i][j] + increase - 1, 9) + 1
            )
        end
      end)
    end)
  end

  def dijkstra(map) do
    xm = Enum.count(map) - 1
    ym = Enum.count(map[0]) - 1

    distances =
      for i <- 0..xm,
          j <- 0..ym,
          reduce: %{} do
        acc -> map_2d_update(acc, i, j, 1_000_000)
      end
      |> map_2d_update(0, 0, 0)

    starting_queue = [{0, 0}]

    final_distances = dijkstra_rec(map, distances, starting_queue, {xm, ym})
    final_distances[xm][ym]
  end

  def dijkstra_rec(_, distances, [], _), do: distances

  def dijkstra_rec(map, distances, queue, maxes) do
    point =
      Enum.min(queue, fn {x1, y1}, {x2, y2} ->
        map_2d_get(distances, x1, y1) <= map_2d_get(distances, x2, y2)
      end)

    neighbors = find_neighbors(point, maxes, distances)

    new_distances =
      neighbors
      |> Enum.reduce(distances, fn neighbor, acc -> update_distance(map, acc, point, neighbor) end)

    new_queue = List.delete(queue, point)
    dijkstra_rec(map, new_distances, new_queue ++ neighbors, maxes)
  end

  def update_distance(map, distances, {x, y}, {nx, ny}) do
    tempDistance = distances[x][y] + map[nx][ny]

    if tempDistance < distances[nx][ny] do
      map_2d_update(distances, nx, ny, tempDistance)
    else
      distances
    end
  end

  def find_neighbors({x, y}, maxes, distances) do
    []
    |> add_neighbor({x + 1, y}, maxes, distances)
    |> add_neighbor({x - 1, y}, maxes, distances)
    |> add_neighbor({x, y + 1}, maxes, distances)
    |> add_neighbor({x, y - 1}, maxes, distances)
  end

  def add_neighbor(list, {x, y}, {x_max, y_max}, distances) do
    if x > -1 and x <= x_max and y > -1 and y <= y_max and distances[x][y] == 1_000_000 do
      [{x, y} | list]
    else
      list
    end
  end

  def map_2d_update(map, i, j, value),
    do:
      map
      |> Map.update(i, %{j => value}, fn inner ->
        inner |> Map.update(j, value, fn _ -> value end)
      end)

  def map_2d_get(map, i, j), do: map |> Map.get(i, %{}) |> Map.get(j, 1_000_000)

  def print_answer(answer), do: IO.puts("Least risky path score: #{answer}")
end

case File.read("./day15values.txt") do
  {:ok, body} -> AOCDay15.find_least_risky_path(body)
  {:error, reason} -> IO.puts(reason)
end
