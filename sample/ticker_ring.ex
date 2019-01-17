defmodule TickerRing do
  @interbal 2000      # 2 secounds
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
    spawn(__MODULE__, :ticker, [next])
  end
  def join_receiver(first,      :undefined, next) do
    IO.puts "secound receiver #{inspect next}"
    :global.register_name(@current, next)
    send first, { :change_next, next }
  end
  def join_receiver(_first,     current,    next) do
    IO.puts "join receiver #{inspect next}"
    :global.re_register_name(@current, next)
    send current, { :change_next, next }
  end

  def receiver(:undefined) do
    receiver(self())
  end
  def receiver(next_pid) do
    receive do
      { :tick } ->
        spawn(__MODULE__, :ticker, [next_pid])
        receiver(next_pid)
      { :change_next, pid } ->
        receiver(pid)
    end
  end

  def ticker(pid) do
    receive do
      # nothing to do
    after @interbal
      -> IO.puts "tick"
         send pid, { :tick }
    end
  end
end
