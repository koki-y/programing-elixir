defmodule Metro.Dijkstra do
  @moduledoc """
  Implemantation of dijkstra algorithm
  """

  @doc """
  Dijkstra
  """
  def dijkstra(from) do
    from_k = Metro.romaji_to_kanji(from, Data.ekimei_list())
    Data.ekimei_list()
        |> seiretu
        |> shokika(from_k)
        |> dijkstra_main(Data.ekikan())
  end
  def dijkstra(from, to) do
    to_k = Metro.romaji_to_kanji(to, Data.ekimei_list())
    dijkstra(from)
        |> Enum.filter(fn %{namae: namae} -> namae == to_k end)
  end

  @doc """
  Dijkstra algorithm
  """
  def dijkstra_main(stations, ekikan) do
    _dijkstra_main(saitan_wo_bunri(stations), ekikan, [])
  end
  defp _dijkstra_main([nearest: _,      rest: []],    _ekikan, result), do: result
  defp _dijkstra_main([nearest: saitan, rest: nokori], ekikan, result) do
    stations = kousin(saitan, nokori, ekikan)
    _dijkstra_main(saitan_wo_bunri(stations), ekikan, result ++ [saitan])
  end

  @doc """
  Make station list

  ## Examples
      iex> stations = [%{kanji: "池袋", kana: "いけぶくろ", romaji: "ikebukuro", shozoku: "有楽町線"}]
      iex> Metro.Dijkstra.make_eki_list(stations)
      [%{namae: "池袋", saitan_kyori: :infinity, temae_list: []}]
  """
  def make_eki_list(stations),     do: _make_eki_list(stations, [])
  defp _make_eki_list([],                       result), do: result
  defp _make_eki_list([%{kanji: kanji} | tail], result) do
    _make_eki_list(tail, result ++ [%{namae: kanji, saitan_kyori: :infinity, temae_list: []}])
  end

  @doc """
  seiretu and reduce same objects

  ## Examples
      iex> stations = [%{kanji: "東池袋", kana: "ひがしいけぶくろ", romaji: "higasiikebukuro", shozoku: "有楽町線"},
      ...>             %{kanji: "池袋",   kana: "いけぶくろ",       romaji: "ikebukuro",       shozoku: "丸ノ内線"},
      ...>             %{kanji: "池袋",   kana: "いけぶくろ",       romaji: "ikebukuro",       shozoku: "有楽町線"}]
      iex> Metro.Dijkstra.seiretu(stations)
      [%{namae: "池袋",   saitan_kyori: :infinity, temae_list: []},
       %{namae: "東池袋", saitan_kyori: :infinity, temae_list: []}]
  """
  def seiretu(stations) do
    stations |> Enum.sort(&(&1[:kana] < &2[:kana]))
             |> make_eki_list
             |> reduce_same_name
  end
  def reduce_same_name(station), do: _reduce_same(station, "", [])
  defp _reduce_same([], _last, result), do: result
  defp _reduce_same([head = %{namae: namae} | tail], last, result)
      when namae != last do
    _reduce_same(tail, namae, result ++ [head])
  end
  defp _reduce_same([_ | tail], last, result) do
    _reduce_same(tail, last, result)
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
      iex> higasiikebukuro = %{namae: "東池袋", saitan_kyori: 0,         temae_list: ["東池袋"]}
      iex> ikebukuro       = %{namae: "池袋",   saitan_kyori: :infinity, temae_list: []}
      iex> Metro.Dijkstra.kousin1(higasiikebukuro, ikebukuro, stations_dist)
      %{namae: "池袋", saitan_kyori: 2.0, temae_list: ["池袋", "東池袋"]}
  """
  def kousin1(p = %{namae: namae1}, q = %{namae: namae2}, ekikan_list) do
    _kousin1(p, q, Metro.get_kyori(namae1, namae2, ekikan_list))
  end
  defp _kousin1(_p, q, :infinity), do: q
  defp _kousin1(%{saitan_kyori: kyori1, temae_list: temae1}, %{namae: namae2, saitan_kyori: kyori2}, new_kyori)
    when kyori2 == :infinity
      or kyori2 > kyori1 + new_kyori do
    %{namae: namae2, saitan_kyori: kyori1 + new_kyori, temae_list: [namae2 | temae1]}
  end
  defp _kousin1(_p, q, _new_kyori), do: q

  @doc """
  Update eki info list

  ## Examples
      iex> stations_dist   = [%{kiten: "東池袋", shuten: "池袋",   keiyu: "有楽町線", kyori: 2.0, jikan: 2},
      ...>                    %{kiten: "東池袋", shuten: "隣乃駅", keiyu: "有楽町線", kyori: 3.0, jikan: 3}]
      iex> higasiikebukuro = %{namae: "東池袋",  saitan_kyori: 0,         temae_list: ["東池袋"]}
      iex> next_stations   = [%{namae: "池袋",   saitan_kyori: :infinity, temae_list: []},
      ...>                    %{namae: "隣乃駅", saitan_kyori: :infinity, temae_list: []}]
      iex> Metro.Dijkstra.kousin(higasiikebukuro, next_stations, stations_dist)
      [%{namae: "池袋", saitan_kyori: 2.0, temae_list: ["池袋", "東池袋"]},
      %{namae: "隣乃駅", saitan_kyori: 3.0, temae_list: ["隣乃駅", "東池袋"]}]
  """
  def kousin(p, v, ekikan_list) do
    Enum.map v, &(kousin1(p, &1, ekikan_list))
  end

  @doc """
  return nearest station and rest.

  ## Examples
      iex> stations = [%{namae: "池袋", saitan_kyori: 2.0, temae_list: ["池袋", "東池袋"]},
      ...>             %{namae: "隣乃駅", saitan_kyori: 3.0, temae_list: ["隣乃駅", "東池袋"]}]
      iex> Metro.Dijkstra.saitan_wo_bunri(stations)
      [nearest: %{namae: "池袋", saitan_kyori: 2.0, temae_list: ["池袋", "東池袋"]},
       rest:    [%{namae: "隣乃駅", saitan_kyori: 3.0, temae_list: ["隣乃駅", "東池袋"]}]]
  """
  def saitan_wo_bunri(stations), do: _bunri(stations, %{saitan_kyori: :infinity}, [], [])
  defp _bunri([], saitan, _mae, nokori), do: [ nearest: saitan, rest: nokori ]
  defp _bunri([head = %{saitan_kyori: kyori}|tail], %{saitan_kyori: current_saitan}, mae, _nokori)
      when kyori < current_saitan do
    _bunri(tail, head, mae ++ [head], mae ++ tail)
  end
  defp _bunri([head|tail], saitan, mae, nokori) do
    _bunri(tail, saitan, mae ++ [head], nokori)
  end
end
