defmodule AOCDay6 do
  def fish_life_simulator(body) do
    initial_fish = body |> String.split(",") |> Enum.map(&String.to_integer(&1))

    fish_after_80 = life_loop(initial_fish, 80)
    IO.puts("fish after 80 days: #{Enum.count(fish_after_80)}")
  end

  def life_loop(fish, 0), do: fish

  def life_loop(fish, day) do
    {new_fish, added_fish} = calc_new_fish(fish, [], [])
    life_loop(new_fish ++ added_fish, day - 1)
  end

  def calc_new_fish([], new_states, added_fish), do: {new_states, added_fish}

  def calc_new_fish([fish | rest], new_fish_states, added_fish) do
    case fish do
      0 -> calc_new_fish(rest, [6 | new_fish_states], [8 | added_fish])
      x -> calc_new_fish(rest, [x - 1 | new_fish_states], added_fish)
    end
  end
end

case File.read("./day6values.txt") do
  {:ok, body} -> AOCDay6.fish_life_simulator(body)
  {:error, reason} -> IO.puts(reason)
end
