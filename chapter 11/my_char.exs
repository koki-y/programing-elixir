defmodule MyChar do
  # Practice-1
  def ascii?([]), do: true
  def ascii?([head | tail]) when 31 < head and head < 127 do
    true and ascii?(tail)
  end
  def ascii?(_list), do: false

  # Practice-2
  def anagram?([], []), do: true
  def anagram?([],  _), do: false
  def anagram?( _, []), do: false
  def anagram?([head | tail], word) do
    anagram?(tail, remove_if_match(word, head))
  end

  def remove_if_match([], _char), do: []
  def remove_if_match([head | tail], char)
    when head == char, do: tail
  def remove_if_match([head | tail], char) do
    [head] ++ remove_if_match(tail, char)
  end

  # Practice-4
  def calc(list), do: _calc(list, '', '',0)

  defp _calc([], fst, snd, 43),           do: to_int(fst) + to_int(snd)
  defp _calc([], fst, snd, 42),           do: to_int(fst) * to_int(snd)
  defp _calc([], fst, snd, 45),           do: to_int(fst) - to_int(snd)
  defp _calc([], fst, snd, 47),           do: to_int(fst) / to_int(snd)
  defp _calc([], _, _, _),                do: nil
  defp _calc([43 | tail], fst, snd, _),   do: _calc(tail, fst, snd, 43)
  defp _calc([42 | tail], fst, snd, _),   do: _calc(tail, fst, snd, 42)
  defp _calc([45 | tail], fst, snd, _),   do: _calc(tail, fst, snd, 45)
  defp _calc([47 | tail], fst, snd, _),   do: _calc(tail, fst, snd, 47)
  defp _calc([head | tail], fst, snd, 0)
    when 47 < head and head < 58,         do: _calc(tail, fst ++ [head], snd, 0)
  defp _calc([head | tail], fst, snd, ope)
    when 47 < head and head < 58,         do: _calc(tail, fst, snd ++ [head], ope)
  defp _calc([32 | tail], fst, snd, ope), do: _calc(tail, fst, snd, ope)
  defp _calc([_|_], _, _, _),             do: nil

  defp to_int(char_seq), do: String.to_integer(String.Chars.to_string(char_seq))
end
