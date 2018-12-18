defmodule FredBetty do
  def return(pid) do
    receive do
      msg -> send pid, msg
      return pid
    end
  end

  def send_message(_, _, 0), do: :ok
  def send_message(fred, betty, n) do
    send fred,  "fred"
    send betty, "betty"
    send_message(fred, betty, n - 1)
  end

  def receive_each(0), do: :ok
  def receive_each(n) do
    receive do
      msg -> IO.puts "#{n}:#{msg}"
      receive_each(n - 1)
    end
  end
end

fred  = spawn FredBetty, :return, [self()]
betty = spawn FredBetty, :return, [self()]

FredBetty.send_message(fred, betty, 100)
FredBetty.receive_each(200)
