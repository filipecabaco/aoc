defmodule Alarm do
  def process(ops, noun, verb) do
    ops =
      ops
      |> List.update_at(1, fn _ -> noun end)
      |> List.update_at(2, fn _ -> verb end)

    try do
      process_opcode(Enum.slice(ops, 0, 4), ops, 0)
    rescue
      _ -> nil
    end
  end

  defp process_opcode(ops, [memory | _], _) when length(ops) < 4, do: memory

  defp process_opcode([99 | _], acc, _), do: process_opcode([], acc, 0)

  defp process_opcode([1, _, _, _] = ops, acc, pos),
    do: (fn res -> process_opcode(Enum.slice(res, pos, 4), res, pos + 4) end).(op(ops, acc, &+/2))

  defp process_opcode([2, _, _, _] = ops, acc, pos),
    do: (fn res -> process_opcode(Enum.slice(res, pos, 4), res, pos + 4) end).(op(ops, acc, &*/2))

  defp process_opcode(_, _, _), do: raise("Unknown Opcode")

  defp op([_, i1, i2, t], acc, op),
    do: List.update_at(acc, t, fn _ -> op.(Enum.at(acc, i1), Enum.at(acc, i2)) end)

  def find_noun_verb(ops, expected, range) do
    0..range
    |> Stream.flat_map(fn noun -> Stream.map(0..range, fn verb -> {noun, verb} end) end)
    |> Stream.map(fn {noun, verb} -> process(ops, noun, verb) end)
    |> Enum.filter(&(&1 == expected))
  end
end

content =
  File.read!("./input")
  |> String.split(",")
  |> Enum.map(&String.to_integer/1)

content
|> Alarm.process(12, 2)
|> IO.inspect(label: "Solution 1")

IO.inspect Alarm.find_noun_verb(content, 19_690_720, 99), label: "Solution 2"
