defmodule TestData do
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
end
