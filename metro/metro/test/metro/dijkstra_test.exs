defmodule DijkstraTest do
  use ExUnit.Case
  doctest Metro.Dijkstra

  test "convert eki_data to dijkstra states." do
    assert Metro.Dijkstra.make_eki_list(TestData.eki_data) == TestData.eki_for_dijk()
  end

  test "shokika ikebukuro as start station." do
    assert Metro.Dijkstra.shokika(TestData.eki_for_dijk(), "池袋") == TestData.initialized()
  end
end
