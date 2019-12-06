defmodule Wires do
  def manhattan_distance([w1, w2]) do
    intersections(path(w1), path(w2))
    |> Enum.map(fn {x, y} -> abs(x + y) end)
    |> Enum.reject(fn v -> v == 0 end)
    |> Enum.sort(fn v1, v2 -> v1 < v2 end)
    |> Enum.at(0)
  end

  def closest_intersection([w1, w2]) do
    p1 = path(w1)
    p2 = path(w2)

    intersections(p1, p2)
    |> Enum.map(fn i -> Enum.find_index(p1, &(i == &1)) + Enum.find_index(p2, &(i == &1)) end)
    |> Enum.reject(fn v -> v == 0 end)
    |> Enum.min()
  end

  defp intersections(p1, p2), do: MapSet.intersection(MapSet.new(p1), MapSet.new(p2))
  defp path(w, acc \\ [{0, 0}])
  defp path([], acc), do: acc
  defp path([d | rest], acc), do: path(rest, acc ++ path_op(d, Enum.at(acc, -1)))

  defp path_op(<<"R"::utf8, mag::binary>>, p), do: move(String.to_integer(mag), p, &right/1)
  defp path_op(<<"L"::utf8, mag::binary>>, p), do: move(String.to_integer(mag), p, &left/1)
  defp path_op(<<"U"::utf8, mag::binary>>, p), do: move(String.to_integer(mag), p, &up/1)
  defp path_op(<<"D"::utf8, mag::binary>>, p), do: move(String.to_integer(mag), p, &down/1)

  defp move(mag, point, op, acc \\ [])
  defp move(0, _, _, acc), do: acc
  defp move(mag, point, op, acc), do: move(mag - 1, op.(point), op, acc ++ [op.(point)])

  defp right({x, y}), do: {x + 1, y}
  defp left({x, y}), do: {x - 1, y}
  defp up({x, y}), do: {x, y + 1}
  defp down({x, y}), do: {x, y - 1}
end

content =
  File.read!("./input3")
  |> String.split()
  |> Enum.map(&String.split(&1, ","))

content
|> Wires.manhattan_distance()
|> IO.inspect(label: "Solution 1")

content
|> Wires.closest_intersection()
|> IO.inspect(label: "Solution 2")
