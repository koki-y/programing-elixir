defmodule FizzBuzz do
  def fizzbuzz(n) do
    cond do
      rem(n, 3) == 0 and rem(n, 5) == 0
        -> "FizzBuzz"
      rem(n, 3) == 0
        -> "Fizz"
      rem(n, 5) == 0
        -> "Buzz"
      true
        -> n
    end
  end
end
