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

  @doc """
  Update eki info
  ## Examples
      iex> stations_dist   = [%{kiten: "東池袋", shuten: "池袋", keiyu: "有楽町線", kyori: 2.0, jikan: 2}]
      iex> higasiikebukuro = %{namae: "東池袋", saitan_kyori:         0, temae_list: ["東池袋"]}
      iex> ikebukuro       = %{namae:   "池袋", saitan_kyori: :infinity, temae_list: []}
      iex> Metro.Dijkstra.kousin1(higasiikebukuro, ikebukuro, stations_dist)
      %{namae: "池袋", saitan_kyori: 2.0, temae_list: ["池袋", "東池袋"]}
  """
  def kousin1(p = %{namae: namae1}, q = %{namae: namae2}, ekikan_list) do
    _kousin1(p, q, Metro.get_kyori(namae1, namae2, ekikan_list))
  end
  defp _kousin1(_p, q, :infinity), do: q
  defp _kousin1(%{saitan_kyori: kyori1, temae_list: temae1}, %{namae: namae2, saitan_kyori: kyori2}, new_kyori)
    when kyori2 == :infinity
      or kyori2 > new_kyori do
    %{namae: namae2, saitan_kyori: kyori1 + new_kyori, temae_list: [namae2 | temae1]}
  end
  defp _kousin1(_p, q, _new_kyori), do: q
end
