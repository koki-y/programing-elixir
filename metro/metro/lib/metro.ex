defmodule Metro do
  @moduledoc """
  Documentation for Metro.
  """

  @doc """
  convert romaji to kanji.

  ## Examples
      iex> stations = [%{kanji: "池袋", kana: "いけぶくろ", romaji: "ikebukuro", shozoku: "有楽町線"}]
      iex> Metro.romaji_to_kanji("ikebukuro", stations)
      "池袋"
  """
  def romaji_to_kanji(_target, []), do: ""
  def romaji_to_kanji(target,  [%{romaji: romaji, kanji: kanji} | _])
    when target == romaji, do: kanji
  def romaji_to_kanji(target,  [_ | tail]), do: romaji_to_kanji(target, tail)

  @doc """
  Get the distance between the two stations.
  The station names are given in kanji.

  ## Examples
      iex> station_dist = [%{kiten: "東池袋", shuten: "池袋", keiyu: "有楽町線", kyori: 2.0, jikan: 2}]
      iex> Metro.get_kyori("池袋", "東池袋", station_dist)
      2.0
  """
  def get_kyori(_from, _to, []), do: :infinity
  def get_kyori(from, to, [%{kiten: kiten, shuten: shuten, kyori: kyori} | _tail])
    when from == kiten  and to == shuten
      or from == shuten and to == kiten, do: kyori
  def get_kyori(from, to, [_ | tail]), do: get_kyori(from, to, tail)

  @doc """
  Print the distance in specific format.
  The station names are given in roman.

  ## Examples
      iex> station = [%{kanji: "東池袋", kana: "ひがしいけぶくろ", romaji: "higasiikebukuro", shozoku: "有楽町線"},
      ...>            %{kanji: "池袋",   kana: "いけぶくろ",      romaji: "ikebukuro",       shozoku: "有楽町線"}]
      iex> station_dist = [%{kiten: "東池袋", shuten: "池袋", keiyu: "有楽町線", kyori: 2.0, jikan: 2}]
      iex> Metro.kyori_wo_hyoji("ikebukuro", "higasiikebukuro", station, station_dist)
      "池袋駅から東池袋駅までは2.0kmです"
  """
  def kyori_wo_hyoji(from, to, eki, ekikan) do
    _kyori_wo_hyoji(from, romaji_to_kanji(from, eki), to, romaji_to_kanji(to, eki), ekikan)
  end
  defp _kyori_wo_hyoji(from, from_k, _to, _to_k, _ekikan)
    when from_k == "", do: _print_not_found(from)
  defp _kyori_wo_hyoji(_from, _from_k, to, to_k, _ekikan)
    when to_k == "",   do: _print_not_found(to)
  defp _kyori_wo_hyoji(_from, from_k, _to, to_k, ekikan) do
    _print_kyori(from_k, to_k, get_kyori(from_k, to_k, ekikan))
  end
  defp _print_kyori(from_k, to_k, :infinity) do
    "#{from_k}駅と#{to_k}駅はつながっていません"
  end
  defp _print_kyori(from_k, to_k, kyori) do
    "#{from_k}駅から#{to_k}駅までは#{kyori}kmです"
  end
  defp _print_not_found(station_name) do
    "#{station_name}という駅は存在しません"
  end
end
