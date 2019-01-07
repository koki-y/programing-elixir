defmodule MetroTest do
  use ExUnit.Case
  doctest Metro

  test "greets the world" do
    assert Metro.hello() == :world
  end
end
