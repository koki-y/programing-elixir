dir = "./cat/cats_nest"
to_process = File.ls!(dir)
             |> Enum.filter(&(Regex.match?(~r/.*\.cat/, &1)))
             |> Enum.map(&(dir <> "/" <> &1))

 Enum.each 1..10, fn num_processes ->
  {time, result} = :timer.tc(
    Scheduler, :run, [num_processes, CatCounter, :cat, to_process])
  if num_processes == 1 do
    IO.puts inspect result
    IO.puts "\n # time (s)"
  end
  :io.format "~2B   ~.2f~n", [num_processes, time/1000000.0]
end
