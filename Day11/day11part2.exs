defmodule AOCDay11 do
  @around [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

  def first_step_all_flash(body) do
    state =
      body
      |> String.split()
      |> turn_grid_into_map()

    game_loop_until_all_flash(state, 100, 0, 0)
    |> print_answer
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
      Map.put(acc, index, {:no_flash, String.to_integer(element)})
    end)
  end

  # game loop
  # if flashes == total_octopuses, return day
  def game_loop_until_all_flash(_, total_octopuses, total_octopuses, step), do: step
  # else, calculate next state and running flashes, decrement day
  def game_loop_until_all_flash(state, total_octopuses, _, step) do
    {flashed_state, flashes} = calc_new_state(state, 0)
    new_state = clear_flashes(flashed_state)

    game_loop_until_all_flash(new_state, total_octopuses, flashes, step + 1)
  end

  def clear_flashes(state) do
    Map.new(state, fn {k, inner} ->
      {k, Map.new(inner, fn {ik, {_, x}} -> {ik, {:no_flash, x}} end)}
    end)
  end

  def calc_new_state(state, flashes) do
    calc_new_state_rec(state, 0, 0, flashes)
  end

  def calc_new_state_rec(state, i, j, flashes) do
    if Map.get(state, i) == nil do
      {state, flashes}
    else
      if map_2d_get(state, i, j) == nil do
        calc_new_state_rec(state, i + 1, 0, flashes)
      else
        case map_2d_get(state, i, j) do
          {:flash, _} -> calc_new_state_rec(state, i, j + 1, flashes)
          {:no_flash, x} -> update_point(state, i, j, x + 1, flashes)
        end
      end
    end
  end

  def update_point(state, i, j, 10, flashes) do
    new_map = map_2d_update(state, i, j, {:flash, 0})
    {flashed_map, new_flashes} = propogate_flash(new_map, i, j, 0)
    calc_new_state_rec(flashed_map, i, j + 1, 1 + flashes + new_flashes)
  end

  def update_point(state, i, j, x, flashes) do
    new_map = map_2d_update(state, i, j, {:no_flash, x})
    calc_new_state_rec(new_map, i, j + 1, flashes)
  end

  def propogate_flash(map, i, j, flashes) do
    @around |> Enum.reduce({map, flashes}, fn {id, jd}, acc -> propogate(acc, i + id, j + jd) end)
  end

  def propogate({map, flashes}, i, j) do
    case map_2d_get(map, i, j) do
      nil ->
        {map, flashes}

      {:no_flash, 9} ->
        map_2d_update(map, i, j, {:flash, 0}) |> propogate_flash(i, j, flashes + 1)

      {:flash, 0} ->
        {map, flashes}

      {:no_flash, x} ->
        {map_2d_update(map, i, j, {:no_flash, x + 1}), flashes}
    end
  end

  # helper functions
  def map_2d_update(map, i, j, value),
    do: map |> Map.update!(i, fn inner -> inner |> Map.update!(j, fn _ -> value end) end)

  def map_2d_get(map, i, j), do: map |> Map.get(i, %{}) |> Map.get(j)

  def print_answer(answer), do: IO.puts("First step when all octopuses flash: #{answer}")
end

case File.read("./day11values.txt") do
  {:ok, body} -> AOCDay11.first_step_all_flash(body)
  {:error, reason} -> IO.puts(reason)
end
