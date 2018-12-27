defmodule TickerRing do
  @interbal 2000      # 2 secound
  @first    :first    # frist receiver
  @current  :current  # current(=end) receiver (not first)

  def start do
    first    = :global.whereis_name(@first)
    current  = :global.whereis_name(@current)
    receiver = spawn(__MODULE__, :receiver, [first])
    join_receiver(first, current, receiver)
  end

  def join_receiver(:undefined, :undefined, next) do
    IO.puts "start first receiver #{inspect next}"
    :global.register_name(@first, next)
  end
  def join_receiver(first,      :undefined, next) do
    IO.puts "next receiver #{inspect next}"
    :global.register_name(@current, next)
    send first, { :next, next }
  end
  def join_receiver(_first,     current,    next) do
    IO.puts "join receiver #{inspect next}"
    :global.re_register_name(@current, next)
    send current, { :next, next }
  end

  def receiver(:undefined) do
    spawn(__MODULE__, :ticker, [self()])
    receiver(self())
  end
  def receiver(pid) do
    receive do
      { :tick } ->
        IO.puts "tock"
        spawn(__MODULE__, :ticker, [pid])
        receiver(pid)
      { :next, next_pid } ->
        receiver(next_pid)
    end
  end

  def ticker(pid) do
    receive do
      # nothing to do
    after
      @interbal ->
#        IO.puts "tick"
        send pid, { :tick }
    end
  end
end
