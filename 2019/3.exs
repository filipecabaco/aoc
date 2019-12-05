defmodule Wires do
  def manhattan_distance(wires) do
    wires
    |> intersections
    |> Enum.map(fn {x, y} -> abs(x + y) end)
    |> Enum.reject(fn v -> v == 0 end)
    |> Enum.sort(fn v1, v2 -> v1 < v2 end)
    |> Enum.at(0)
  end

  def intersections([w1, w2], c \\ [{0, 0}]),
    do: MapSet.intersection(MapSet.new(path(w1, c)), MapSet.new(path(w2, c)))

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

File.read!("./input3")
|> String.split()
|> Enum.map(&String.split(&1, ","))
|> Wires.manhattan_distance()
|> IO.inspect(label: "Solution 1")
