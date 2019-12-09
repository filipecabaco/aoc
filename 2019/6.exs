defmodule Orbit do
  def calculate(map) do
    os = map
    |> Enum.map(&(String.split(&1,")")))
    |> Enum.reduce(%{},&orbits/2)
    |> Map.to_list()

    os
    |> Enum.map(&(count(&1, os, [])))
    |> List.flatten
    |> Enum.count
  end
  def transfer(map) do
    os = map
    |> Enum.map(&(String.split(&1,")")))
    |> Enum.reduce(%{},&orbits/2)
    |> Map.to_list()

    os
    |> Enum.map(&(count(&1, os, [])))
    |> Enum.filter(fn v -> Enum.any?(List.flatten(v), &(&1 == "SAN")) end)
    |> Enum.filter(fn v -> Enum.any?(List.flatten(v), &(&1 == "YOU")) end)
  end

  defp orbits([p,o],acc), do: Map.merge(acc, Map.update(acc, p, [o], fn v-> v ++ [o] end))

  defp count({_,o}, os, acc) do
    res = os
    |> Enum.filter(fn {p, _} -> Enum.any?(o, &(&1==p)) end)
    |> Enum.map(fn v -> count(v,os,[]) end)

    o ++ acc ++ res
  end
end

File.read!("./input6")
|> String.split()
|> Orbit.calculate()
|> IO.inspect(label: "Solution 1")

"""
COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
"""
|> String.split()
|> Orbit.transfer()
