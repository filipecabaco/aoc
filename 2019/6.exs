defmodule Orbit do
  def calculate(map),
    do:
      orbits(map)
      |> (fn m -> Enum.map(m, &count(&1, m, [])) end).()
      |> List.flatten()
      |> Enum.count()

  def transfer(map) do
    os =
      orbits(map)
      |> (fn m -> Enum.map(m, &count(&1, m, [])) end).()
      |> Enum.filter(fn v -> Enum.any?(List.flatten(v), &(&1 == "SAN")) end)
      |> Enum.filter(fn v -> Enum.any?(List.flatten(v), &(&1 == "YOU")) end)

    san = os |> Enum.map(&find_person(&1, "SAN", 0)) |> List.flatten() |> Enum.min()
    you = os |> Enum.map(&find_person(&1, "YOU", 0)) |> List.flatten() |> Enum.min()
    you + san
  end

  defp orbits(map),
    do:
      map
      |> Enum.map(&String.split(&1, ")"))
      |> Enum.reduce(%{}, &orbits/2)
      |> Map.to_list()

  defp orbits([p, o], acc), do: Map.merge(acc, Map.update(acc, p, [o], fn v -> v ++ [o] end))

  defp count({_, o}, os, acc),
    do:
      os
      |> Enum.filter(fn {p, _} -> Enum.any?(o, &(&1 == p)) end)
      |> Enum.map(fn v -> count(v, os, []) end)
      |> (fn res -> o ++ acc ++ res end).()

  defp find_person(os, person, acc) do
    case(Enum.any?(os, &(&1 == person))) do
      true -> acc
      false -> os |> Enum.filter(&is_list/1) |> Enum.map(&find_person(&1, person, acc + 1))
    end
  end
end

File.read!("./input6")
|> String.split()
|> Orbit.calculate()
|> IO.inspect(label: "Solution 1")

File.read!("./input6")
|> String.split()
|> Orbit.transfer()
|> IO.inspect(label: "Solution 2")
