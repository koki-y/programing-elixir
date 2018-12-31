defmodule Stack.Stash do
  use GenServer

  def start_link(stack) do
    { :ok, _pid } = GenServer.start_link(Stack.Stash, stack)
  end
  def save(pid, stack) do
    GenServer.cast(pid, {:save, stack})
  end
  def get(pid) do
    GenServer.call(pid, :get)
  end

  ##
  # Implemantation

  def init(args) do
    { :ok, args }
  end
  def handle_call(:get, _from, current) do
    { :reply, current, current }
  end
  def handle_cast({:save, stack}, _current) do
    { :noreply, stack }
  end
end
