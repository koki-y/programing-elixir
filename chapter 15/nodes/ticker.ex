defmodule Ticker do

  @interval 2000    # 2 seconds
  @name     :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send :global.whereis_name(@name), { :register, client_pid }
  end

  def generator(queue, clients) do
    receive do
      { :register, pid } ->
        IO.puts "registering #{inspect pid}"
        generator(queue ++ [pid], clients ++ [pid])
    after
      @interval ->
        IO.puts "tick"
        next_queue = send_and_dequeue(queue, clients)
        generator(next_queue, clients)
    end
  end

  def send_and_dequeue([], []),            do: []
  def send_and_dequeue([head | tail], _)   do
    send head, { :tick }
    tail
  end
  def send_and_dequeue([], [first | rest]) do
    send first, { :tick }
    rest
  end
end

defmodule Client do
  def start do
    pid = spawn(__MODULE__, :receiver)
    Ticker.register(pid)
  end

  def receiver do
    receive do
      { :tick, num } ->
        IO.puts "tock"
        receiver()
    end
  end
end
