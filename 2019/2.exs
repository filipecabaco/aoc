defmodule Alarm do
  def process(ops, noun, verb) do
    ops =
      ops
      |> List.update_at(1, fn _ -> noun end)
      |> List.update_at(2, fn _ -> verb end)

    {noun, verb, process_opcode(Enum.slice(ops, 0, 4), ops, 0)}
  end

  defp process_opcode([], [mem | _], _), do: mem

  defp process_opcode([99 | _], acc, _), do: process_opcode([], acc, 0)

  defp process_opcode([1 | _] = ops, acc, pos) do
    acc = op(ops, acc, &+/2)
    process_opcode(Enum.slice(acc, pos + 4, 4), acc, pos + 4)
  end

  defp process_opcode([2 | _] = ops, acc, pos) do
    acc = op(ops, acc, &*/2)
    process_opcode(Enum.slice(acc, pos + 4, 4), acc, pos + 4)
  end

  defp op([_, i1, i2, t], acc, op),
    do: List.update_at(acc, t, fn _ -> op.(Enum.at(acc, i1), Enum.at(acc, i2)) end)

  def find_noun_verb(ops, expected, range) do
    0..range
    |> Stream.flat_map(fn noun -> Stream.map(0..range, fn verb -> {noun, verb} end) end)
    |> Stream.map(fn {noun, verb} -> process(ops, noun, verb) end)
    |> Enum.filter(fn {_, _, res} -> res == expected end)
    |> hd()
    |> (fn {noun, verb, _} -> 100 * noun + verb end).()
  end
end

content =
  File.read!("./input2_edited.txt")
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

content
|> Alarm.process(12, 2)
|> (fn {_, _, v} -> v end).()
|> IO.inspect(label: "Solution 1")

IO.inspect(Alarm.find_noun_verb(content, 19_690_720, 99), label: "Solution 2")
