defmodule CatCounter do
  def cat(scheduler) do
    send scheduler, { :ready, :cat, self()}

    receive do
      { :cat, file_name, client } ->
        send client, {:answer, file_name, count_cat(File.read! file_name), self()}
        cat(scheduler)
      { :shutdown } -> exit(:normal)
    end
  end

  def count_cat(<<binary::binary>>), do: _count_cat(binary, 0)

  defp _count_cat("", counter), do: counter
  defp _count_cat(<<h1::8, h2::8, h3::8, rest::binary>>, counter)
      when <<h1>> == "c"
       and <<h2>> == "a"
       and <<h3>> == "t"
    do
    _count_cat(rest, counter + 1)
  end
  defp _count_cat(<<_::8, rest::binary>>, counter) do
    _count_cat(rest, counter)
  end
end
