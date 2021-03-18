defmodule Transaction do
  defstruct date: Date.utc_today, type: nil, value: 0, from: nil, to: nil
  @transactions = "transactions.txt"

  def save(type, from, value, date, to \\ nil) do

    transactions = get_transactions() ++

      %__MODULE__{type: type, value: value, date: date, from: from, to: to}
      File.write(@transactions, :erlang.term_to_binary(transactions))
      transactions
  end

  defp get_transactions() do
    {:ok, binary} = File.read(@transactions)
    binary
    |> :erlang.binary_to_term()
  end

  def get_all(), do: get_transactions()

  def get_by_year(year), do: Enum.filter(get_transactions(), &(&1.date.year == year))

  def get_by_month(month), do: Enum.filter(get_transactions(), &(&1.date.year == year && &1.date.month == month))

  def get_by_day(date), do: Enum.filter(get_transactions(), &(&1.date == date))

  defp calc(transactions) do
    Enum.reduce(transactions, 0, fn x, acc -> acc + x.value  end)
  end

  def calc_by_month(year, month) do
    transactions = get_by_month(year, month)
    {transactions, calc(transactions)}
  end

  def calc_by_year(year) do
    transactions = get_by_year(year)
    {transactions, calc(transactions)}
  end

  def calc_by_day(date) do
    transactions = get_by_day(date)
    {transactions, calc(transactions)}
  end
end