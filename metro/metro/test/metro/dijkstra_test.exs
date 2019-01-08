defmodule DijkstraTest do
  use ExUnit.Case
  doctest Metro.Dijkstra

  def eki_for_dijk do
    [
      %{namae: "飯田橋",   saitan_kyori: :infinity, temae_list: []},
      %{namae: "江戸川橋", saitan_kyori: :infinity, temae_list: []},
      %{namae: "護国寺",   saitan_kyori: :infinity, temae_list: []},
      %{namae: "東池袋",   saitan_kyori: :infinity, temae_list: []},
      %{namae: "池袋",     saitan_kyori: :infinity, temae_list: []}
    ]
  end
  def initialized do
    [
      %{namae: "飯田橋",   saitan_kyori: :infinity, temae_list: []},
      %{namae: "江戸川橋", saitan_kyori: :infinity, temae_list: []},
      %{namae: "護国寺",   saitan_kyori: :infinity, temae_list: []},
      %{namae: "東池袋",   saitan_kyori: :infinity, temae_list: []},
      %{namae: "池袋",     saitan_kyori: 0,         temae_list: ["池袋"]}
    ]
  end

  test "convert eki_data to dijkstra states." do
    assert Metro.Dijkstra.make_eki_list(MetroTest.eki_data) == eki_for_dijk()
  end

  test "shokika ikebukuro as start station." do
    assert Metro.Dijkstra.shokika(eki_for_dijk(), "池袋") == initialized()
  end
end
