defmodule AOCDay5 do
  def find_safe_places(body) do
    paths = convert_input(body)

    heat_map = create_map(paths)
    num_heated_spots = find_heated_spots(heat_map)
    IO.puts("Heated spots #: #{num_heated_spots}")
  end

  def find_heated_spots(heat_map) do
    heat_map
    |> Enum.reduce(0, fn {_, inner}, acc ->
      Enum.reduce(inner, acc, fn {_, v}, acc ->
        if v > 1 do
          acc + 1
        else
          acc
        end
      end)
    end)
  end

  def create_map(paths) do
    paths
    |> Enum.reduce(%{}, fn path, acc -> add_path_to_map(acc, path) end)
  end

  def add_path_to_map(map, path) do
    path
    |> convert_path_to_line()
    |> Enum.reduce(map, fn {x1, y1}, acc ->
      Map.update(acc, x1, %{y1 => 1}, fn inner_map ->
        Map.update(inner_map, y1, 1, fn x -> x + 1 end)
      end)
    end)
  end

  def convert_path_to_line(%{from: {x1, y1}, to: {x2, y2}}) do
    {xs, ys} =
      cond do
        x1 == x2 ->
          {List.duplicate(x1, Range.size(y1..y2)), y1..y2}

        y1 == y2 ->
          {x1..x2, List.duplicate(y1, Range.size(x1..x2))}

        true ->
          {x1..x2, y1..y2}
      end

    Enum.zip(xs, ys)
  end

  def convert_input(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn line -> convert_line(line) end)
  end

  def convert_line(line) do
    line_map =
      Regex.named_captures(~r/(?<x1>[0-9]+),(?<y1>[0-9]+) -> (?<x2>[0-9]+),(?<y2>[0-9]+)/, line)

    x1 = String.to_integer(line_map["x1"])
    y1 = String.to_integer(line_map["y1"])

    x2 = String.to_integer(line_map["x2"])
    y2 = String.to_integer(line_map["y2"])
    %{from: {x1, y1}, to: {x2, y2}}
  end
end

case File.read("./day5values.txt") do
  {:ok, body} -> AOCDay5.find_safe_places(body)
  {:error, reason} -> IO.puts(reason)
end
