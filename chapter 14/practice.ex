defmodule Practice do
  import :timer, only: [ sleep: 1 ]

  def child(parent_pid) do
    send parent_pid, "I'll go away!"
    # exit(:boom)
    raise("Exception!")
  end

  def receive_all do
    receive do
      msg -> IO.puts(msg)
      receive_all()
    after
      500 -> IO.puts "done"
    end
  end
  def run do
    spawn_monitor(Practice, :child, [self()])
    # spawn_link(Practice, :child, [self()])
    sleep 500
    receive_all()
  end
end

Practice.run
