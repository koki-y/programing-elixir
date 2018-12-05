defmodule MyEnum do
  def all?([], _func), do: true
  def all?([head | tail], func) do
    func.(head) and all?(tail, func)
  end
end
