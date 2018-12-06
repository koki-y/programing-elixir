defmodule BookShelf do

  def add_tax([], _tax_rates), do: []
  def add_tax([order = [id: _, ship_to: to, net_amount: amount]| tail], tax_rates) do
    if tax_rates[to] do
      [order ++ [total_amount: amount * (1 + tax_rates[to])]] ++ add_tax(tail, tax_rates)
    else
      [order ++ [total_amount: amount]] ++ add_tax(tail, tax_rates)
    end
  end
end
