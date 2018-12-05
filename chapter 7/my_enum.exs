defmodule MyEnum do
  # Practice-5
  def all?([], _func), do: true
  def all?([head | tail], func) do
    func.(head) and all?(tail, func)
  end

  def each([], _func), do: :ok
  def each([head | tail], func) do
    func.(head)
    each(tail, func)
  end

  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head) do
      [head] ++ filter(tail, func)
    else
      filter(tail, func)
    end
  end

  def split(list, num), do: _split(list, [], num)
  defp _split([head | tail], value, num) when num > 0 do
      _split(tail, value ++ [head], num - 1)
  end
  defp _split(list, value, _num), do: {value, list}

  def take([head | tail], num) when num > 0 do
      [head] ++ take(tail, num - 1)
  end
  def take(_list, _num), do: []
end
