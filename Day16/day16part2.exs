defmodule AOCDay16 do
  def version_numbers_sum(body) do
    body
    |> convert_to_binary()
    |> read_meta([], %{}, 1000)
    |> solve_packets_top()
    |> List.first()
    |> IO.inspect(label: "Answer")
  end

  def solve_packets_top({packets, _}), do: solve_packets(packets)

  def solve_packets(packets) do
    Enum.map(packets, fn x -> solve_packet(x) end)
  end

  def solve_packet(packet) do
    case packet[:type_id] do
      "000" -> solve_packets(packet.sub_packets) |> Enum.sum()
      "001" -> solve_packets(packet.sub_packets) |> Enum.product()
      "010" -> solve_packets(packet.sub_packets) |> Enum.min()
      "011" -> solve_packets(packet.sub_packets) |> Enum.max()
      "100" -> convert_literal(packet.nums)
      "101" -> solve_packets(packet.sub_packets) |> greater_than()
      "110" -> solve_packets(packet.sub_packets) |> less_than()
      "111" -> solve_packets(packet.sub_packets) |> equal_to()
    end
  end

  def convert_literal(nums) do
    {integer, _} =
      nums
      |> Enum.join()
      |> Integer.parse(2)
    integer
  end

  def greater_than([first, second | _]) do
    if first > second do
      1
    else
      0
    end
  end

  def less_than([first, second | _]) do
    if first < second do
      1
    else
      0
    end
  end

  def equal_to([first, second | _]) do
    if first == second do
      1
    else
      0
    end
  end

  def convert_to_binary(body) do
    body
    |> String.graphemes()
    |> Enum.reduce("", fn x, acc -> acc <> convert_to_binary_str(x) end)
  end

  def read_meta("", packets, _, _), do: {packets, ""}
  def read_meta(binary, packets, _, 0), do: {packets, binary}

  def read_meta(binary, packets, current_packet, num_of_packets) do
    {version, type_rest} = String.split_at(binary, 3)
    {type_id, rest} = String.split_at(type_rest, 3)

    if Enum.all?(String.codepoints(binary), fn x -> x == "0" end) do
      {packets, binary}
    else

      new_current =
        current_packet
        |> Map.put(:version, version)
        |> Map.put(:type_id, type_id)

      case type_id do
        "100" -> read_literal(rest, packets, new_current, num_of_packets)
        _ -> read_operator(rest, packets, new_current, num_of_packets)
      end
    end
  end

  def read_literal(binary, packets, current_packet, num_of_packets) do
    {literal, rest} = String.split_at(binary, 5)
    {more?, num} = String.split_at(literal, 1)

    new_current =
      current_packet
      |> Map.update(:nums, [num], fn nums -> nums ++ [num] end)

    case more? do
      "1" -> read_literal(rest, packets, new_current, num_of_packets)
      "0" -> read_meta(rest, packets ++ [new_current], %{}, num_of_packets - 1)
    end
  end

  def read_operator(binary, packets, current_packet, num_of_packets) do
    {length_modifier, rest} = String.split_at(binary, 1)
    new_current = Map.put(current_packet, :length_modifier, length_modifier)

    case length_modifier do
      "0" -> read_15_bits_len_num_bits(rest, packets, new_current, num_of_packets)
      "1" -> read_11_bits_num_packets(rest, packets, new_current, num_of_packets)
    end
  end

  def read_15_bits_len_num_bits(binary, packets, current_packet, num_of_packets) do
    {bit_15_packet_size, rest} = String.split_at(binary, 15)

    {packet_size, _} = Integer.parse(bit_15_packet_size, 2)

    {packets_string, rest2} = String.split_at(rest, packet_size)
    {sub_packets, _} = read_meta(packets_string, [], %{}, 1000)

    new_current =
      current_packet
      |> Map.put(:packet_size, packet_size)
      |> Map.put(:sub_packets, sub_packets)

    read_meta(rest2, packets ++ [new_current], %{}, num_of_packets - 1)
  end

  def read_11_bits_num_packets(binary, packets, current_packet, current_num_of_packets) do
    {bit_11_packet_num, rest} = String.split_at(binary, 11)

    {num_of_packets, _} = Integer.parse(bit_11_packet_num, 2)

    {sub_packets, rest2} = read_meta(rest, [], %{}, num_of_packets)

    new_current =
      current_packet
      |> Map.put(:num_of_packets, num_of_packets)
      |> Map.put(:sub_packets, sub_packets)

    read_meta(rest2, packets ++ [new_current], %{}, current_num_of_packets - 1)
  end

  def convert_to_binary_str(hexa) do
    case hexa do
      "0" -> "0000"
      "1" -> "0001"
      "2" -> "0010"
      "3" -> "0011"
      "4" -> "0100"
      "5" -> "0101"
      "6" -> "0110"
      "7" -> "0111"
      "8" -> "1000"
      "9" -> "1001"
      "A" -> "1010"
      "B" -> "1011"
      "C" -> "1100"
      "D" -> "1101"
      "E" -> "1110"
      "F" -> "1111"
      _ -> raise "no match for #{hexa}"
    end
  end
end

case File.read("./day16values.txt") do
  {:ok, body} -> AOCDay16.version_numbers_sum(body)
  {:error, reason} -> IO.puts(reason)
end
