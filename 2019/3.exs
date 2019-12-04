defmodule Wires do
  def manhattan_distance(wires) do
    wires
    |> intersections
    |> Enum.map(fn {x, y} -> {x + y, :math.sqrt(:math.pow(x, 2) + :math.pow(y, 2))} end)
    |> Enum.sort(fn {_, d1}, {_,d2} -> d1 > d2 end)
    |> IO.inspect
  end

  def intersections([w1, w2], c \\ [{0, 0}]),
    do: MapSet.intersection(MapSet.new(path(w1, c)), MapSet.new(path(w2, c)))

  defp path([], acc), do: acc
  defp path([d | rest], acc), do: path(rest, acc ++ path_op(d, Enum.at(acc, -1)))

  defp path_op(<<"R"::utf8, mag::binary>>, p), do: right(String.to_integer(mag), p, [])
  defp path_op(<<"L"::utf8, mag::binary>>, p), do: left(String.to_integer(mag), p, [])
  defp path_op(<<"U"::utf8, mag::binary>>, p), do: up(String.to_integer(mag), p, [])
  defp path_op(<<"D"::utf8, mag::binary>>, p), do: down(String.to_integer(mag), p, [])

  defp right(0, _, acc), do: acc
  defp right(mag, {x, y}, acc), do: right(mag - 1, {x + 1, y}, acc ++ [{x + 1, y}])

  defp left(0, _, acc), do: acc
  defp left(mag, {x, y}, acc), do: left(mag - 1, {x - 1, y}, acc ++ [{x - 1, y}])

  defp up(0, _, acc), do: acc
  defp up(mag, {x, y}, acc), do: up(mag - 1, {x, y + 1}, acc ++ [{x, y + 1}])

  defp down(0, _, acc), do: acc
  defp down(mag, {x, y}, acc), do: down(mag - 1, {x, y - 1}, acc ++ [{x, y - 1}])
end

# File.read!("./input3")
# """
# R75,D30,R83,U83,L12,D49,R71,U7,L72
# U62,R66,U55,R34,D71,R55,D58,R83
# """
"""
R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51
U98,R91,D20,R16,D67,R40,U7,R15,U6,R7
"""
|> String.split()
|> Enum.map(&String.split(&1, ","))
|> Wires.manhattan_distance()
|> IO.inspect()
