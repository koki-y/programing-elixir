defmodule MyList do
  # Practice-0
  # Sum without accumulator.
  def sum([]),            do: 0
  def sum([head | tail]), do: head + _sum(tail)

  # Practice-1
  def mapsum(list, func), do: _mapsum(list, 0, func)

  defp _mapsum([], value, _func), do: value
  defp _mapsum([head | tail], value, func) do
    _mapsum(tail, value+func.(head), func)
  end

  # Practice-2
  def max(list), do: _max(list, 0)

  defp _max([], value), do: value
  defp _max([head | tail], value)
    when head > value,  do: _max(tail, head)
  defp _max([head | tail], value)
    when head <= value, do: _max(tail, value)

  # Practice-3
  def ceasar(list, n), do: _ceasar(list, [], n)

  defp _ceasar([], value, _n), do: value
  defp _ceasar([head | tail], value, n) when head + n > 122  do
    _ceasar(tail, value ++ [97 + rem(head + n, 123)], n)
  end
  defp _ceasar([head | tail], value, n) when head + n <= 122 do
    _ceasar(tail, value ++ [head + n], n)
  end

  # Practice-4
  def span(list, from, to), do: _span(list, 0, [], from, to)
  defp _span([], _, value, _, _), do: value
  defp _span([head | tail], count, value, from, to)
    when from <= count and count <= to do
    _span(tail, count + 1, value ++ [head], from, to)
  end
  defp _span([head | tail], count, value, from, to) do
    _span(tail, count + 1, value, from , to)
  end
end
