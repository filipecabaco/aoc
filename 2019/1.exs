defmodule FuelCalculator do
  def fuel(m), do: Float.floor(m / 3) - 2

  def fuelReducer(m, acc) do
    case fuel(m) do
      f when f > 0 -> fuelReducer(f, acc + f)
      _ -> acc
    end
  end
end

content =
  File.read!("./input.txt")
  |> String.split()
  |> Enum.map(&String.to_integer/1)

# Problem 1

fuelForModules =
  content
  |> Enum.map(&FuelCalculator.fuel/1)
  |> Enum.sum()
  |> IO.inspect(label: "Solution 1")

# Problem 2

fuelForFuel =
  content
  |> Enum.map(&FuelCalculator.fuel/1)
  |> Enum.map(&FuelCalculator.fuelReducer(&1, 0))
  |> Enum.sum()

IO.inspect(fuelForFuel + fuelForModules, label: "Solution 2")
