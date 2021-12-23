defmodule AOCDay17 do
  def find_max_y(body) do
    body
    |> convert_input_to_ranges()
    |> IO.inspect()
    |> calc_best_velocity()
    |> Enum.map(fn x -> highest_y(x) end)
    |> Enum.max()
    |> IO.inspect(label: "Answer")
  end

  def convert_input_to_ranges(body) do
    name_map =
      Regex.named_captures(
        ~r/target area: x=(?<x_min>[\-0-9]+)..(?<x_max>[\-0-9]+), y=(?<y_min>[\-0-9]+)..(?<y_max>[\-0-9]+)/,
        body
      )

    {x_min, _} = Integer.parse(name_map["x_min"])
    {x_max, _} = Integer.parse(name_map["x_max"])
    {y_min, _} = Integer.parse(name_map["y_min"])
    {y_max, _} = Integer.parse(name_map["y_max"])
    # for x <- x_min..x_max, y <- y_min..y_max, do: {x, y}
    {x_min..x_max, y_min..y_max}
  end

  def highest_y({_, y_vel}) do
    highest_y_rec(0, y_vel)
  end

  def highest_y_rec(y_pos, y_vel) do
    {next_y_pos, next_y_vel} = calc_next_y(y_pos, y_vel)

    if (next_y_pos < y_pos) do
      y_pos
    else
      highest_y_rec(next_y_pos, next_y_vel)
    end
  end

  def calc_best_velocity({x_range, y_range} = ranges) do
    for x_vel <- 0..Enum.max(x_range), y_vel <- 0..abs(Enum.min(y_range)), hits_target?(ranges, {x_vel, y_vel}, {0,0}), do: {x_vel, y_vel}
  end

  def calc_next_x(old_x, vel_x) when vel_x == 0 do
    {old_x, 0}
  end

  def calc_next_x(old_x, vel_x) when vel_x > 0 do
    {old_x + vel_x, vel_x - 1}
  end

  def calc_next_x(old_x, vel_x) when vel_x < 0 do
    {old_x + vel_x, vel_x + 1}
  end

  def calc_next_y(old_y, vel_y) do
    {old_y + vel_y, vel_y - 1}
  end

  def hits_target?({x_range, y_range} = ranges, {x_vel, y_vel}, {x, y}) do
    {next_x_pos, next_x_vel} = calc_next_x(x, x_vel)
    {next_y_pos, next_y_vel} = calc_next_y(y, y_vel)

    if (Enum.member?(x_range, next_x_pos) and Enum.member?(y_range, next_y_pos)) do
      true
    else
      if (next_y_pos < Enum.min(y_range)) do
        false
      else
        hits_target?(ranges, {next_x_vel, next_y_vel}, {next_x_pos, next_y_pos})
      end
    end
  end
end

case File.read("./day17values.txt") do
  {:ok, body} -> AOCDay17.find_max_y(body)
  {:error, reason} -> IO.puts(reason)
end
