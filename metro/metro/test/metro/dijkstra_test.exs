defmodule DijkstraTest do
  use ExUnit.Case
  doctest Metro.Dijkstra

  test "convert eki_data to dijkstra states." do
    assert Metro.Dijkstra.make_eki_list(TestData.eki_data) == TestData.eki_for_dijk()
  end

  test "shokika ikebukuro as start station." do
    assert Metro.Dijkstra.shokika(TestData.eki_for_dijk(), "池袋") == TestData.initialized()
  end

  test "update eki infomation." do
    higasiikebukuro = %{namae: "東池袋", saitan_kyori:       1.0, temae_list: ["東池袋", "始乃駅"]}
    ikebukuro       = %{namae:   "池袋", saitan_kyori: :infinity, temae_list: []}
    assert Metro.Dijkstra.kousin1(higasiikebukuro, ikebukuro, TestData.ekikan_data())
      == %{namae: "池袋", saitan_kyori: 3.0, temae_list: ["池袋", "東池袋", "始乃駅"]}
  end
  test "don't update eki infomation. because not saitan." do
    higasiikebukuro = %{namae: "東池袋", saitan_kyori:       1.0, temae_list: ["東池袋", "始乃駅"]}
    ikebukuro       = %{namae:   "池袋", saitan_kyori:       2.0, temae_list: ["池袋","始乃駅"]}
    assert Metro.Dijkstra.kousin1(higasiikebukuro, ikebukuro, TestData.ekikan_data())
      == %{namae: "池袋", saitan_kyori: 2.0, temae_list: ["池袋","始乃駅"]}
  end
  test "don't update eki infomation. because the station not found." do
    higasiikebukuro = %{namae: "東池袋", saitan_kyori:       1.0, temae_list: ["東池袋", "始乃駅"]}
    siranai         = %{namae: "知無駅", saitan_kyori: :infinity, temae_list: []}
    assert Metro.Dijkstra.kousin1(higasiikebukuro, siranai, TestData.ekikan_data())
      == %{namae: "知無駅", saitan_kyori: :infinity, temae_list: []}
  end
end
