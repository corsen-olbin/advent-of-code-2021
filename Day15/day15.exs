defmodule AOCDay15 do
  def find_least_risky_path(body) do
    body
    |> String.split()
    |> turn_grid_into_map()
    |> find_least_risky_new()
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

  def find_least_risky_new(map) do
    queue = :queue.in({1, 0}, :queue.new())
    starting_queue = :queue.in({0, 1}, queue)

    starting_calcd_map = %{0 => %{0 => 0}}

    x_max = Enum.count(map) - 1
    y_max = Enum.count(map[0]) - 1

    final_calcd_map =
      find_least_risky_new_rec(
        map,
        starting_queue,
        starting_calcd_map,
        {x_max, y_max}
      )

    final_calcd_map[x_max][y_max]
  end

  def find_least_risky_new_rec(map, queue, calcd_map, {max_x, max_y} = maxes) do
    {{:value, {x, y}}, rest} = :queue.out(queue)

    cond do
      :queue.is_empty(rest) ->
        map_2d_update(
          calcd_map,
          x,
          y,
          min(map_2d_get(calcd_map, x - 1, y), map_2d_get(calcd_map, x, y - 1)) + map[x][y]
        )

      map_2d_get(calcd_map, x, y) != 1_000_000 ->
        find_least_risky_new_rec(map, rest, calcd_map, maxes)

      x == max_x and y == max_y ->
        find_least_risky_new_rec(
          map,
          rest,
          map_2d_update(
            calcd_map,
            x,
            y,
            min(map_2d_get(calcd_map, x - 1, y), map_2d_get(calcd_map, x, y - 1)) + map[x][y]
          ),
          maxes
        )

      x >= max_x and not (y >= max_y) ->
        find_least_risky_new_rec(
          map,
          :queue.in({x, y + 1}, rest),
          map_2d_update(
            calcd_map,
            x,
            y,
            min(map_2d_get(calcd_map, x - 1, y), map_2d_get(calcd_map, x, y - 1)) + map[x][y]
          ),
          maxes
        )

      y >= max_y and not (x >= max_x) ->
        find_least_risky_new_rec(
          map,
          :queue.in({x + 1, y}, rest),
          map_2d_update(
            calcd_map,
            x,
            y,
            min(map_2d_get(calcd_map, x - 1, y), map_2d_get(calcd_map, x, y - 1)) + map[x][y]
          ),
          maxes
        )

      true ->
        find_least_risky_new_rec(
          map,
          :queue.in({x, y + 1}, :queue.in({x + 1, y}, rest)),
          map_2d_update(
            calcd_map,
            x,
            y,
            min(map_2d_get(calcd_map, x - 1, y), map_2d_get(calcd_map, x, y - 1)) + map[x][y]
          ),
          maxes
        )
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
