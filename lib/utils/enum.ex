defmodule Utils.Enum do
  def combine(left, right) do
    combine([], left, right)
  end

  defp combine(acc, [l | left], [r | right]), do: combine(acc ++ [l, r], left, right)
  defp combine(acc, [l | left], []), do: combine(acc ++ [l], left, [])
  defp combine(acc, [], [r | right]), do: combine(acc ++ [r], [], right)
  defp combine(acc, [], []), do: acc
end
