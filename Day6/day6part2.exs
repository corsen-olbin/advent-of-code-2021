defmodule AOCDay6 do
  def fish_life_simulator(body) do
    initial_fish = body |> String.split(",") |> Enum.map(&String.to_integer(&1))

    fish_nums =
      Enum.reduce(0..8, %{}, fn x, acc ->
        Map.put(acc, x, Enum.count(initial_fish, fn fish -> fish == x end))
      end)

    IO.inspect(fish_nums)
    fish_nums_after_256 = life_loop(fish_nums, 256)
    count = fish_nums_after_256 |> Map.values() |> Enum.sum()
    IO.puts("fish after 256 days: #{count}")
  end

  def life_loop(fish_nums, 0), do: fish_nums

  def life_loop(fish_nums, day) do
    fish_nums = calc_new_fish(fish_nums)
    life_loop(fish_nums, day - 1)
  end

  def calc_new_fish(fish_nums) do
    new_state_func = fn original, {key, _} ->
      case key do
        6 -> {key, original[0] + original[7]}
        x -> {key, original[rem(x + 1, 9)]}
      end
    end

    for pair <- fish_nums, into: %{}, do: new_state_func.(fish_nums, pair)
  end
end

case File.read("./day6values.txt") do
  {:ok, body} -> AOCDay6.fish_life_simulator(body)
  {:error, reason} -> IO.puts(reason)
end
