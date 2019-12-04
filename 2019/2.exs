defmodule Alarm do
  def process(ops), do: process_opcode(Enum.slice(ops, 0, 4), ops, 0)

  defp process_opcode([], acc, _), do: acc

  defp process_opcode([1 | _] = ops, acc, pos) do
    res = sum(ops, acc)
    process_opcode(Enum.slice(res, pos, 4), res, pos + 4)
  end

  defp process_opcode([2 | _] = ops, acc, pos) do
    res = mult(ops, acc)
    process_opcode(Enum.slice(res, pos, 4), res, pos + 4)
  end

  defp process_opcode([99 | _], acc, _), do: process_opcode([], acc, 0)

  defp sum([_, i1, i2, t | _], acc),
    do: List.update_at(acc, t, fn _ -> Enum.at(acc, i1) + Enum.at(acc, i2) end)

  defp mult([_, i1, i2, t | _], acc),
    do: List.update_at(acc, t, fn _ -> Enum.at(acc, i1) * Enum.at(acc, i2) end)
end

File.read!("./input2_edited.txt")
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> Alarm.process()
|> Enum.at(0)
|> IO.inspect(label: "Solution 1")
