defmodule Password do
  def crack([s, f]),
    do:
      String.to_integer(s)..String.to_integer(f)
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(&adjacent/1)
      |> Enum.map(&is_cont_inc/1)
      |> Enum.reject(&is_nil/1)
      |> Enum.count()


  def better_crack([s, f]),
    do:
      String.to_integer(s)..String.to_integer(f)
      |> Enum.map(&Integer.to_string/1)
      |> Enum.map(&adjacent/1)
      |> Enum.map(&is_cont_inc/1)
      |> Enum.map(&unique_adjacent/1)
      |> Enum.reject(&is_nil/1)
      |> Enum.count()

  defp adjacent(<<a::utf8, a::utf8, _::binary-size(4)>> = value), do: value
  defp adjacent(<<_::binary-size(1), b::utf8, b::utf8, _::binary-size(3)>> = value), do: value
  defp adjacent(<<_::binary-size(2), c::utf8, c::utf8, _::binary-size(2)>> = value), do: value
  defp adjacent(<<_::binary-size(3), d::utf8, d::utf8, _::binary-size(1)>> = value), do: value
  defp adjacent(<<_a::binary-size(4), e::utf8, e::utf8>> = value), do: value

  defp adjacent(_), do: nil

  defp is_cont_inc(<<a::utf8, b::utf8, c::utf8, d::utf8, e::utf8, f::utf8>> = value) do
    a = String.to_integer(<<a>>)
    b = String.to_integer(<<b>>)
    c = String.to_integer(<<c>>)
    d = String.to_integer(<<d>>)
    e = String.to_integer(<<e>>)
    f = String.to_integer(<<f>>)

    cond do
      a <= b and b <= c and c <= d and d <= e and e <= f -> value
      true -> nil
    end
  end

  defp is_cont_inc(_), do: nil

  defp unique_adjacent(<<a::utf8, a::utf8, b::utf8, c::utf8, d::utf8, e::utf8>> = value)
       when a != b and a != c and a != d and a != e,
       do: value

  defp unique_adjacent(<<a::utf8, b::utf8, b::utf8, c::utf8, d::utf8, e::utf8>> = value)
       when b != a and b != c and b != d and b != e,
       do: value

  defp unique_adjacent(<<a::utf8, b::utf8, c::utf8, c::utf8, d::utf8, e::utf8>> = value)
       when c != a and c != b and c != d and c != e,
       do: value

  defp unique_adjacent(<<a::utf8, b::utf8, c::utf8, d::utf8, d::utf8, e::utf8>> = value)
       when d != a and d != b and d != c and d != e,
       do: value

  defp unique_adjacent(<<a::utf8, b::utf8, c::utf8, d::utf8, e::utf8, e::utf8>> = value)
       when e != a and e != b and e != c and e != d,
       do: value

  defp unique_adjacent(_), do: nil
end

"125730-579381"
|> String.split("-")
|> Password.crack()
|> IO.inspect(label: "Solution 1")

"125730-579381"
|> String.split("-")
|> Password.better_crack()
|> IO.inspect(label: "Solution 2")
