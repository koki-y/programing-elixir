defmodule MyPrime do
  # Practice-4
  def span(from, to), do: _span(from, to, 0)
  defp _span(_from, to, count) when count >  to,  do: []
  defp _span(from, to, count)  when count >= from do
      [count] ++ _span(from, to, count + 1)
  end
  defp _span(from, to, count) do
    _span(from, to, count + 1)
  end

  def primes(n) do
    for x <- span(2, n),  Enum.all?(span(2, x - 1), &(rem(x, &1) != 0)), do: x
  end
end
