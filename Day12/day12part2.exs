defmodule AOCDay12 do
  def find_num_of_passages_that_hit_small_caves_once(body) do
    body
    |> String.split("\r\n")
    |> create_graph()
    |> IO.inspect()
    |> find_small_cave_passages()
    |> print_answer()
  end

  def create_graph(lines) do
    lines
    |> Enum.map(fn line -> regex(line) end)
    |> Enum.reduce(%{}, fn line_map, acc -> add_to_graph(acc, line_map) end)
  end

  def add_to_graph(graph, %{"first" => first, "second" => second}) do
    cond do
      first == "start" ->
        Map.update(graph, first, [second], fn list -> [second | list] end)

      second == "start" ->
        Map.update(graph, second, [first], fn list -> [first | list] end)

      first == "end" ->
        Map.update(graph, second, [first], fn list -> [first | list] end)

      second == "end" ->
        Map.update(graph, first, [second], fn list -> [second | list] end)

      true ->
        Map.update(graph, first, [second], fn list -> [second | list] end)
        |> Map.update(second, [first], fn list -> [first | list] end)
    end
  end

  def regex(line) do
    Regex.named_captures(~r/(?<first>[a-zA-Z]+)-(?<second>[a-zA-Z]+)/, line)
  end

  def find_small_cave_passages(graph) do
    find_small_cave_passages_rec(graph, ["start"], graph["start"], 0)
  end

  def find_small_cave_passages_rec(_, _, [], num_of_passages), do: num_of_passages

  def find_small_cave_passages_rec(graph, existing_path, [head | list], num_of_passages) do
    cond do
      # if small cave, already been there, and existing path already has two of same small cave
      # skip over it since it's not a valid path
      is_small_cave?(head) and Enum.member?(existing_path, head) and
          has_two_small_caves?(existing_path) ->
        find_small_cave_passages_rec(graph, existing_path, list, num_of_passages)
      # if hit an "end", increment # of passages since that is a full path
      head == "end" ->
        find_small_cave_passages_rec(graph, existing_path, list, num_of_passages + 1)
      # else find num of passages by taking the valid path and adding it to total num of passages
      true ->
        find_small_cave_passages_rec(
          graph,
          existing_path,
          list,
          num_of_passages +
            find_small_cave_passages_rec(graph, [head | existing_path], graph[head], 0)
        )
    end
  end

  defp is_small_cave?(cave) do
    cave != "end" and
      cave
      |> String.graphemes()
      |> Enum.all?(fn x -> x >= "\u0061" and x <= "\u007A" end)
  end

  def has_two_small_caves?(existing_path) do
    existing_path
    |> Enum.reduce(%{}, fn element, acc ->
      Map.update(acc, element, 1, fn value -> value + 1 end)
    end)
    |> Enum.any?(fn {k, count} -> is_small_cave?(k) and count > 1 end)
  end

  def print_answer(answer),
    do: IO.puts("# of paths that only hit small caves once at most: #{answer}")
end

case File.read("./day12values.txt") do
  {:ok, body} -> AOCDay12.find_num_of_passages_that_hit_small_caves_once(body)
  {:error, reason} -> IO.puts(reason)
end
