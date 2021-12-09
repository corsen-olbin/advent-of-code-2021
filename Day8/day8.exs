defmodule AOCDay8 do
  def find_easy_digit_frequency(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.split(x, "|") end)
    |> Enum.map(fn [_, output | []] -> String.split(output, " ", trim: true) end)
    |> Enum.map(fn line -> count_1478_digits(line) end)
    |> Enum.sum()
    |> print_answer
  end

  def count_1478_digits(line) do
    check = fn single ->
      case String.length(single) do
        7 -> true
        4 -> true
        3 -> true
        2 -> true
        _ -> false
      end
    end

    Enum.count(line, check)
  end

  def print_answer(count), do: IO.puts("# of times 1, 4, 7, and 8 appear: #{count}")
end

case File.read("./day8values.txt") do
  {:ok, body}      -> AOCDay8.find_easy_digit_frequency(body)
  {:error, reason} -> IO.puts(reason)
end
