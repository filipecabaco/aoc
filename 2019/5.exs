defmodule Alarm do
  def process(ops), do: process_opcode(Enum.slice(ops, 0, 1), Enum.slice(ops, 1, 3), 0, ops)

  defp process_opcode([], _, _, acc), do: acc

  defp process_opcode([opcode], args, pos, acc) do
    %{opcode: opcode, par_mode: par_mode} = decompose_opcode(opcode)

    if opcode == :halt do
      process_opcode([], [], 0, acc)
    else
      {pos, acc} = process(opcode, par_mode, args, pos, acc)
      process_opcode(Enum.slice(acc, pos, 1), Enum.slice(acc, pos + 1, 3), pos, acc)
    end
  end

  defp process(:sum, %{p1: p1, p2: p2}, [a1, a2, a3], pos, acc) do
    a1 = process_param(p1, a1, acc)
    a2 = process_param(p2, a2, acc)
    {pos + steps(:sum), update(a3, fn _ -> a1 + a2 end, acc)}
  end

  defp process(:mult, %{p1: p1, p2: p2}, [a1, a2, a3], pos, acc) do
    a1 = process_param(p1, a1, acc)
    a2 = process_param(p2, a2, acc)
    {pos + steps(:mult), update(a3, fn _ -> a1 * a2 end, acc)}
  end

  defp process(:input, _, [t | _], pos, acc),
    do:
      {pos + steps(:input),
       update(
         t,
         fn _ ->
           IO.puts("Input value please")
           IO.read(:stdio, :line) |> String.trim() |> String.to_integer()
         end,
         acc
       )}

  defp process(:output, %{p1: p1}, [a1 | _], pos, acc) do
    IO.inspect(process_param(p1, a1, acc), label: "Output")
    {pos + steps(:output), acc}
  end

  defp process(:jump_true, %{p1: p1, p2: p2}, [a1, a2 | _], pos, acc) do
    case process_param(p1, a1, acc) != 0 do
      true -> {process_param(p2, a2, acc), acc}
      false -> {pos + steps(:jump_true), acc}
    end
  end

  defp process(:jump_false, %{p1: p1, p2: p2}, [a1, a2 | _], pos, acc) do
    case process_param(p1, a1, acc) == 0 do
      true -> {process_param(p2, a2, acc), acc}
      false -> {pos + steps(:jump_false), acc}
    end
  end

  defp process(:less, %{p1: p1, p2: p2}, [a1, a2, a3], pos, acc) do
    {pos + steps(:less),
     update(
       a3,
       fn _ ->
         case process_param(p1, a1, acc) < process_param(p2, a2, acc) do
           true -> 1
           false -> 0
         end
       end,
       acc
     )}
  end

  defp process(:equals, %{p1: p1, p2: p2}, [a1, a2, a3], pos, acc) do
    {pos + steps(:equals),
     update(
       a3,
       fn _ ->
         case process_param(p1, a1, acc) == process_param(p2, a2, acc) do
           true -> 1
           false -> 0
         end
       end,
       acc
     )}
  end

  defp update(t, op, acc), do: List.update_at(acc, t, op)

  defp process_param(:position, i, acc), do: Enum.at(acc, i)
  defp process_param(:immediate, i, _), do: i

  defp decompose_opcode(opcode, acc \\ [])
  defp decompose_opcode(0, [e]), do: param_map(0, 0, 0, 0, e)
  defp decompose_opcode(0, [d, e]), do: param_map(0, 0, 0, d, e)
  defp decompose_opcode(0, [c, d, e]), do: param_map(0, 0, c, d, e)
  defp decompose_opcode(0, [b, c, d, e]), do: param_map(0, b, c, d, e)
  defp decompose_opcode(0, [a, b, c, d, e]), do: param_map(a, b, c, d, e)

  defp decompose_opcode(opcode, acc),
    do: decompose_opcode(trunc(opcode / 10), [rem(opcode, 10)] ++ acc)

  defp param_map(a, b, c, d, e),
    do: %{
      opcode: op("#{d}#{e}"),
      par_mode: %{p1: param_mode(c), p2: param_mode(b), p3: param_mode(a)}
    }

  defp op("99"), do: :halt
  defp op("01"), do: :sum
  defp op("02"), do: :mult
  defp op("03"), do: :input
  defp op("04"), do: :output
  defp op("05"), do: :jump_true
  defp op("06"), do: :jump_false
  defp op("07"), do: :less
  defp op("08"), do: :equals

  defp param_mode(0), do: :position
  defp param_mode(1), do: :immediate

  defp steps(:halt), do: 0
  defp steps(:sum), do: 4
  defp steps(:mult), do: 4
  defp steps(:input), do: 2
  defp steps(:output), do: 2
  defp steps(:jump_true), do: 3
  defp steps(:jump_false), do: 3
  defp steps(:less), do: 4
  defp steps(:equals), do: 4
end

File.read!("./input5")
|> String.split(",")
|> Enum.map(&String.to_integer/1)
|> Alarm.process()
