defmodule AOCDay4 do
  @wins [
    # rows
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}],
    [{1, 0}, {1, 1}, {1, 2}, {1, 3}, {1, 4}],
    [{2, 0}, {2, 1}, {2, 2}, {2, 3}, {2, 4}],
    [{3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 4}],
    [{4, 0}, {4, 1}, {4, 2}, {4, 3}, {4, 4}],
    # columns
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}],
    [{0, 1}, {1, 1}, {2, 1}, {3, 1}, {4, 1}],
    [{0, 2}, {1, 2}, {2, 2}, {3, 2}, {4, 2}],
    [{0, 3}, {1, 3}, {2, 3}, {3, 3}, {4, 3}],
    [{0, 4}, {1, 4}, {2, 4}, {3, 4}, {4, 4}]
    # diagonals
    # [{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}],
    # [{0, 4}, {1, 3}, {2, 2}, {3, 1}, {4, 0}]
  ]

  def find_winning_bingo_card(input) do
    [numbers_called | boards_input] = String.split(input, "\r\n\r\n")

    numbers = String.split(numbers_called, ",")

    readable_boards = make_boards_readable(boards_input)

    {called_nums, board} = loop_game_until_win([], numbers, readable_boards)

    non_called_nums = find_non_called_nums_on_card(called_nums, board)

    winning_num = called_nums
    |> List.first()
    |> String.to_integer()

    sum =
      non_called_nums
      |> Enum.map(&String.to_integer(&1))
      |> Enum.sum()

    IO.puts("Sum of non-called nums times winning num: #{sum * winning_num}")
  end

  def make_boards_readable(boards) do
    Enum.map(boards, fn x -> make_board_readable(x) end)
  end

  def make_board_readable(board) do
    rows = String.split(board, "\r\n", trim: true)

    Enum.with_index(rows)
    |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, v, make_row_readable(k)) end)
  end

  def make_row_readable(row) do
    nums = String.split(row, ~r/\s/, trim: true)
    Enum.with_index(nums) |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, v, k) end)
  end

  def is_winning_card?(nums_called, board) do
    @wins
    |> Enum.any?(fn x ->
      Enum.all?(x, fn {x1, x2} ->
        Enum.member?(nums_called, board[x1][x2])
      end)
    end)
  end

  def loop_game_until_win(nums_called, [next_num | future_nums], boards) do
    new_nums_called = [next_num | nums_called]
    winning_card = Enum.filter(boards, fn x -> is_winning_card?(new_nums_called, x) end)

    case Enum.count(winning_card) do
      0 -> loop_game_until_win(new_nums_called, future_nums, boards)
      1 -> {new_nums_called, List.first(winning_card)}
      _ -> raise "how was there more than one winning card?!"
    end
  end

  def find_non_called_nums_on_card(nums_called, board) do
    Enum.reduce(
      board,
      [],
      fn {_, v}, acc ->
        acc ++
          (Map.values(v) |> Enum.filter(fn x -> !Enum.member?(nums_called, x) end))
      end
    )
  end

  # def find_winning_row(nums_called, winning_card) do
  #   win =
  #     @wins
  #     |> Enum.find(fn x ->
  #       Enum.all?(x, fn {x1, x2} ->
  #         Enum.member?(nums_called, winning_card[x1][x2])
  #       end)
  #     end)

  #   Enum.map(win, fn {x1, x2} -> winning_card[x1][x2] end)
  # end
end

case File.read("./day4values.txt") do
  {:ok, body} -> AOCDay4.find_winning_bingo_card(body)
  {:error, reason} -> IO.puts(reason)
end
