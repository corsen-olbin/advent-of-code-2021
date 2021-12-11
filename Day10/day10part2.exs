defmodule AOCDay10 do
  def find_sum_of_illegal_chars(body) do
    body
    |> String.split()
    |> find_closing_char_sequences()
    |> Enum.map(fn x -> convert_to_points(x) end)
    |> Enum.sort()
    |> find_middle()
    |> print_answer()
  end

  def convert_to_points(x) do
    Enum.reduce(x, 0, fn char, acc -> (acc * 5) + convert_char_to_points(char) end)
  end

  def convert_char_to_points(x) do
    case x do
      ")" -> 1
      "]" -> 2
      "}" -> 3
      ">" -> 4
    end
  end

  def find_middle(list) do
    mid = div(length(list), 2)
    {mid_value, list} = List.pop_at(list, mid)
    mid_value
  end

  def print_answer(answer), do: IO.puts("Middle score: #{answer}")

  def find_closing_char_sequences(lines), do: find_closing_char_sequences_rec(lines, [])

  def find_closing_char_sequences_rec([], acc), do: acc

  def find_closing_char_sequences_rec([head | lines], acc) do
    case find_closing_char_sequence(String.split(head, "", trim: true), []) do
      {:ok, closing_chars} -> find_closing_char_sequences_rec(lines, [closing_chars | acc])
      {:illegal, _} -> find_closing_char_sequences_rec(lines, acc)
    end
  end

  def find_closing_char_sequence([], closing_chars), do: {:ok, closing_chars}

  def find_closing_char_sequence([head | tail], stack) do
    {shead, stail} =
      case Enum.empty?(stack) do
        true -> {nil, []}
        false -> {hd(stack), tl(stack)}
      end

    case head do
      "(" -> find_closing_char_sequence(tail, [")" | stack])
      "[" -> find_closing_char_sequence(tail, ["]" | stack])
      "{" -> find_closing_char_sequence(tail, ["}" | stack])
      "<" -> find_closing_char_sequence(tail, [">" | stack])
      closing when closing == shead -> find_closing_char_sequence(tail, stail)
      illegal -> {:illegal, illegal}
    end
  end
end

case File.read("./day10values.txt") do
  {:ok, body} -> AOCDay10.find_sum_of_illegal_chars(body)
  {:error, reason} -> IO.puts(reason)
end
