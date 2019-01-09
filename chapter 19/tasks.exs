defmodule Fib do
  def of(0), do: 1
  def of(1), do: 1
  def of(n), do: of(n-1) + of(n-2)
end

IO.puts "Start the task"
# worker = Task.async(fn -> Fib.of(20) end)
worker = Task.async(Fib, :of, [20])

IO.puts "Do something else"

IO.puts "Wait for the task"
result = Task.await(worker)

IO.puts "The result is #{result}"
