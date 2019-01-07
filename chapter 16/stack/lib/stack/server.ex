defmodule Stack.Server do
  use GenServer

  def init(args) do
    { :ok, args }
  end

  def handle_call(:pop, _from, [head | tail]) do
    { :reply, head, tail }
  end

  def handle_cast({:push, val}, list) do
    { :noreply, list ++ [val] }
  end
end
