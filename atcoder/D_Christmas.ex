defmodule RunRun do
  def feed(_, 0), do: 0
  def feed(dimension, appetite) do
    burger_size = round(:math.pow 2, (dimension + 2)) - 3
    amount_of_p = round(:math.pow 2, (dimension + 1)) - 1
    cond do
      appetite < burger_size
        -> feed(dimension - 1 , appetite - 1)
      appetite == burger_size
        -> amount_of_p + 1
      appetite > burger_size
        -> amount_of_p + 1 + feed(dimension, appetite - burger_size - 1)
    end
  end
end

[x, n] = IO.read(:line)
         |> String.replace("\r", "")
         |> String.replace("\n", "")
         |> String.split(" ")
         |> Enum.map(&String.to_integer/1)
IO.puts RunRun.feed x, n
