defmodule Stack.Server do
  use GenServer

  ##
  # External interface
  def start_link(stash_pid) do
    GenServer.start_link(__MODULE__, stash_pid, name: __MODULE__)
  end
  def pop do
    GenServer.call(__MODULE__, :pop)
  end
  def push(value) do
    GenServer.cast(__MODULE__, { :push, value })
  end

  ##
  # Implementation
  def init(stash_pid) do
    current_stack = Stack.Stash.get stash_pid
    { :ok, {current_stack, stash_pid} }
  end
  def handle_call(:pop, _from, {[head | tail], stash_pid}) do
    { :reply, head, {tail, stash_pid} }
  end
  def handle_cast({:push, val}, {list, stash_pid}) do
    { :noreply, {list ++ [val], stash_pid} }
  end
  def terminate(_reason, {state, stash_pid}) do
    Stack.Stash.save stash_pid, state
  end
end
