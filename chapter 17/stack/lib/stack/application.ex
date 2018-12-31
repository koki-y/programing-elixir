defmodule Stack.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    { :ok, _pid } = Stack.Supervisor.start_link([5, "cat", 6])
  end
end
