defmodule Check do
  def ok!(result) do
    case result do
      {:ok, data} -> data
      {_, error}  -> raise error
    end
  end
end
