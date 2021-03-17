defmodule Transaction do
  defstruct date: Date.utc_today, type: nil, value: 0, from: nil, to: nil
  @transactions = "transactions.txt"

  def save(type, from, value, date, to \\ nil) do

    transactions = get_transactions() ++

      %__MODULE__{type: type, value: value, date: date, from: from, to: to}
      File.write(@transactions, :erlang.term_to_binary(transactions))
      transactions
  end

  def get_all(), do: get_transactions()

  defp get_transactions() do
    {:ok, binary} = File.read(@transactions)
    binary
    |> :erlang.binary_to_term()
  end
end