defmodule Metro.Dijkstra do
  @moduledoc """
  Implemantation of dijkstra algorithm
  """

  @doc """
  Make station list
  ## Examples
      iex> stations = [%{kanji: "池袋", kana: "いけぶくろ", romaji: "ikebukuro", shozoku: "有楽町線"}]
      iex> Metro.Dijkstra.make_eki_list(stations)
      [%{namae: "池袋", saitan_kyori: :infinity, temae_list: []}]
  """
  def make_eki_list(stations),     do: _make_eki_list(stations, [])
  defp _make_eki_list([], result), do: result
  defp _make_eki_list([%{kanji: kanji} | tail], result) do
    _make_eki_list(tail, result ++ [%{namae: kanji, saitan_kyori: :infinity, temae_list: []}])
  end

  @doc """
  Initialize start station.
  ## Examples
      iex> stations = [
      ...>  %{namae: "飯田橋",   saitan_kyori: :infinity, temae_list: []},
      ...>  %{namae: "江戸川橋", saitan_kyori: :infinity, temae_list: []},
      ...>  %{namae: "護国寺",   saitan_kyori: :infinity, temae_list: []},
      ...>  %{namae: "東池袋",   saitan_kyori: :infinity, temae_list: []},
      ...>  %{namae: "池袋",     saitan_kyori: :infinity, temae_list: []}
      ...>]
      iex> Metro.Dijkstra.shokika(stations, "池袋")
      [%{namae: "飯田橋",   saitan_kyori: :infinity, temae_list: []},
       %{namae: "江戸川橋", saitan_kyori: :infinity, temae_list: []},
       %{namae: "護国寺",   saitan_kyori: :infinity, temae_list: []},
       %{namae: "東池袋",   saitan_kyori: :infinity, temae_list: []},
       %{namae: "池袋",     saitan_kyori: 0, temae_list: ["池袋"]}]
  """
  def shokika(stations, start_station), do: _shokika(stations, start_station, [])
  defp _shokika([%{namae: namae} | tail], start_station, result)
    when namae == start_station do
      result ++ [%{namae: namae, saitan_kyori: 0, temae_list: [namae]}] ++ tail
  end
  defp _shokika([head | tail], start_station, result) do
    _shokika(tail, start_station, result ++ [head])
  end
end
