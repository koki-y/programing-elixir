defmodule MetroTest do
  use ExUnit.Case
  doctest Metro

  def eki_data do
    [
      %{romaji: "iidabashi", kana: "いいだばし", kanji: "飯田橋", shozoku: "有楽町線"},
      %{kanji: "江戸川橋", kana: "えどがわばし", romaji: "edogawabasi", shozoku: "有楽町線"},
      %{kanji: "護国寺", kana: "ごこくじ", romaji: "gokokuji", shozoku: "有楽町線"},
      %{kanji: "東池袋", kana: "ひがしいけぶくろ", romaji: "higasiikebukuro", shozoku: "有楽町線"},
      %{kanji: "池袋", kana: "いけぶくろ", romaji: "ikebukuro", shozoku: "有楽町線"}
    ]
  end
  def ekikan_data do
    [
      %{kiten: "市ヶ谷", shuten: "飯田橋", keiyu: "有楽町線", kyori: 1.1, jikan: 2},
      %{kiten: "飯田橋", shuten: "江戸川橋", keiyu: "有楽町線", kyori: 1.6, jikan: 3},
      %{kiten: "江戸川橋", shuten: "護国寺", keiyu: "有楽町線", kyori: 1.3, jikan: 2},
      %{kiten: "護国寺", shuten: "東池袋", keiyu: "有楽町線", kyori: 1.1, jikan: 2},
      %{kiten: "東池袋", shuten: "池袋", keiyu: "有楽町線", kyori: 2.0, jikan: 2},
      %{kiten: "池袋", shuten: "要町", keiyu: "有楽町線", kyori: 1.2, jikan: 2}
    ]
  end

  test "ikebukuro to kanji" do
    assert Metro.romaji_to_kanji("ikebukuro", eki_data()) == "池袋"
  end
  test "iebukuro couldn't to kanji" do
    assert Metro.romaji_to_kanji("iebukuro", eki_data()) == ""
  end
  test "when data list is empty" do
    assert Metro.romaji_to_kanji("ikebukuro", []) == ""
  end

  test "get kyori between ikebukuro and higasiikebukuro" do
    assert Metro.get_kyori("池袋", "東池袋", ekikan_data()) == 2.0
  end
  test "get kyori between higasiikebukuro and ikebukuro" do
    assert Metro.get_kyori("東池袋", "池袋", ekikan_data()) == 2.0
  end
  test "couldn't get kyori between ikebukuro and gokokuji" do
    assert Metro.get_kyori("池袋", "護国寺", ekikan_data()) == :infinity
  end

  test "print kyori announcement between ikebukuro and higasiikebukuro in roman" do
    assert Metro.kyori_wo_hyoji("ikebukuro", "higasiikebukuro", eki_data(), ekikan_data())
             == "池袋駅から東池袋駅までは2.0kmです"
  end
  test "print kyori announcement between higasiikebukuro and ikebukuro in roman" do
    assert Metro.kyori_wo_hyoji("higasiikebukuro", "ikebukuro", eki_data(), ekikan_data())
             == "東池袋駅から池袋駅までは2.0kmです"
  end
  test "print anouncement ikebukuro and gokokuji are not connected" do
    assert Metro.kyori_wo_hyoji("ikebukuro", "gokokuji", eki_data(), ekikan_data())
             == "池袋駅と護国寺駅はつながっていません"
  end
  test "when given station is not found" do
    assert Metro.kyori_wo_hyoji("iebukuro", "gokokuji", eki_data(), ekikan_data())
              == "iebukuroという駅は存在しません"
  end
  test "when secound given station is not found" do
    assert Metro.kyori_wo_hyoji("ikebukuro", "ookuji", eki_data(), ekikan_data())
              == "ookujiという駅は存在しません"
  end
end
