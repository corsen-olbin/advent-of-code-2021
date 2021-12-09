defmodule AOCDay8 do
  def find_easy_digit_frequency(body) do
    body
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.split(x, "|") end)
    |> Enum.map(fn [signals, output | []] ->
      {figure_out_signals(signals), String.split(output, " ", trim: true)}
    end)
    |> Enum.map(fn x -> convert_to_ints(x) end)
    |> Enum.sum()
    |> print_answer
  end

  def figure_out_signals(signals) do
    signal_list = String.split(signals, " ", trim: true)
    length_groups = Enum.group_by(signal_list, fn x -> String.length(x) end)

    one = List.first(length_groups[2])
    seven = List.first(length_groups[3])
    four = List.first(length_groups[4])
    eight = List.first(length_groups[7])

    six = Enum.find(length_groups[6], fn x -> segment_overlap_count(x, one) == 1 end)
    nine = Enum.find(length_groups[6], fn x -> segment_overlap_count(x, four) == 4 end)

    three = Enum.find(length_groups[5], fn x -> segment_overlap_count(x, one) == 2 end)
    five = Enum.find(length_groups[5], fn x -> segment_overlap_count(x, six) == 5 end)
    two = Enum.find(length_groups[5], fn x -> segment_overlap_count(x, nine) == 4 end)

    zero = Enum.find(length_groups[6], fn x -> segment_overlap_count(x, five) == 4 end)

    %{}
    |> Map.put(String.graphemes(one) |> Enum.sort(), "1")
    |> Map.put(String.graphemes(two) |> Enum.sort(), "2")
    |> Map.put(String.graphemes(three) |> Enum.sort(), "3")
    |> Map.put(String.graphemes(four) |> Enum.sort(), "4")
    |> Map.put(String.graphemes(five) |> Enum.sort(), "5")
    |> Map.put(String.graphemes(six) |> Enum.sort(), "6")
    |> Map.put(String.graphemes(seven) |> Enum.sort(), "7")
    |> Map.put(String.graphemes(eight) |> Enum.sort(), "8")
    |> Map.put(String.graphemes(nine) |> Enum.sort(), "9")
    |> Map.put(String.graphemes(zero) |> Enum.sort(), "0")
  end

  def segment_overlap_count(n1, n2) do
    n1
    |> String.graphemes()
    |> Enum.count(fn letter -> String.contains?(n2, letter) end)
  end

  def convert_to_ints({map, output}) do
    {num, _} =
      output
      |> Enum.reduce("", fn x, acc -> acc <> find_value_in_map(map, x) end)
      |> Integer.parse()
    num
  end

  def find_value_in_map(map, jumbled_key) do
    key_letters = String.graphemes(jumbled_key) |> Enum.sort()
    map[key_letters]
  end

  def print_answer(sum), do: IO.puts("Sum of all: #{sum}")
end

case File.read("./day8values.txt") do
  {:ok, body} -> AOCDay8.find_easy_digit_frequency(body)
  {:error, reason} -> IO.puts(reason)
end
