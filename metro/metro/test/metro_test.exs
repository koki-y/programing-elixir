defmodule MetroTest do
  use ExUnit.Case
  doctest Metro

  test "ikebukuro to kanji" do
    assert Metro.romaji_to_kanji("ikebukuro", TestData.eki_data()) == "池袋"
  end
  test "iebukuro couldn't to kanji" do
    assert Metro.romaji_to_kanji("iebukuro", TestData.eki_data()) == ""
  end
  test "when data list is empty" do
    assert Metro.romaji_to_kanji("ikebukuro", []) == ""
  end

  test "get kyori between ikebukuro and higasiikebukuro" do
    assert Metro.get_kyori("池袋", "東池袋", TestData.ekikan_data()) == 2.0
  end
  test "get kyori between higasiikebukuro and ikebukuro" do
    assert Metro.get_kyori("東池袋", "池袋", TestData.ekikan_data()) == 2.0
  end
  test "couldn't get kyori between ikebukuro and gokokuji" do
    assert Metro.get_kyori("池袋", "護国寺", TestData.ekikan_data()) == :infinity
  end

  test "print kyori announcement between ikebukuro and higasiikebukuro in roman" do
    assert Metro.kyori_wo_hyoji("ikebukuro", "higasiikebukuro", TestData.eki_data(), TestData.ekikan_data())
             == "池袋駅から東池袋駅までは2.0kmです"
  end
  test "print kyori announcement between higasiikebukuro and ikebukuro in roman" do
    assert Metro.kyori_wo_hyoji("higasiikebukuro", "ikebukuro", TestData.eki_data(), TestData.ekikan_data())
             == "東池袋駅から池袋駅までは2.0kmです"
  end
  test "print anouncement ikebukuro and gokokuji are not connected" do
    assert Metro.kyori_wo_hyoji("ikebukuro", "gokokuji", TestData.eki_data(), TestData.ekikan_data())
             == "池袋駅と護国寺駅はつながっていません"
  end
  test "when given station is not found" do
    assert Metro.kyori_wo_hyoji("iebukuro", "gokokuji", TestData.eki_data(), TestData.ekikan_data())
              == "iebukuroという駅は存在しません"
  end
  test "when secound given station is not found" do
    assert Metro.kyori_wo_hyoji("ikebukuro", "ookuji", TestData.eki_data(), TestData.ekikan_data())
              == "ookujiという駅は存在しません"
  end
end
