defmodule AOCDay10 do
  def find_sum_of_illegal_chars(body) do
    body
    |> String.split()
    |> find_illegal_chars()
    |> Enum.map(fn x -> convert_to_points(x) end)
    |> Enum.sum()
    |> print_answer()
  end

  def convert_to_points(x) do
    case x do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  def print_answer(answer), do: IO.puts("Sum of illegal characters: #{answer}")

  def find_illegal_chars(lines), do: find_illegal_chars_rec(lines, [])

  def find_illegal_chars_rec([], acc), do: acc

  def find_illegal_chars_rec([head | lines], acc) do
    case find_illegal_char(String.split(head, "", trim: true), []) do
      {:ok} -> find_illegal_chars_rec(lines, acc)
      {:illegal, char} -> find_illegal_chars_rec(lines, [char | acc])
    end
  end

  def find_illegal_char([], _), do: {:ok}

  def find_illegal_char([head | tail], stack) do
    {shead, stail} =
      case Enum.empty?(stack) do
        true -> {nil, []}
        false -> {hd(stack), tl(stack)}
      end

    case head do
      "(" -> find_illegal_char(tail, [")" | stack])
      "[" -> find_illegal_char(tail, ["]" | stack])
      "{" -> find_illegal_char(tail, ["}" | stack])
      "<" -> find_illegal_char(tail, [">" | stack])
      closing when closing == shead -> find_illegal_char(tail, stail)
      illegal -> {:illegal, illegal}
    end
  end
end

case File.read("./day10values.txt") do
  {:ok, body} -> AOCDay10.find_sum_of_illegal_chars(body)
  {:error, reason} -> IO.puts(reason)
end
