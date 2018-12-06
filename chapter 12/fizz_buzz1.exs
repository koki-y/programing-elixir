defmodule FizzBuzz do
  def fizzbuzz(n) do
    _fizzbuzz(rem(n, 5), rem(n, 3), n)
  end

  defp _fizzbuzz(0, 0, _), do: "FizzBuzz"
  defp _fizzbuzz(0, _, _), do: "Fizz"
  defp _fizzbuzz(_, 0, _), do: "Buzz"
  defp _fizzbuzz(_, _, n), do: n
end
