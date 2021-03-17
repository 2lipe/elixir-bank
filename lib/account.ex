defmodule Account do

  defstruct user: User, balance: 1000
  @accounts "accounts.txt"

  def register(user) do
    accounts = get_accounts()
    case get_accounts_by_email(user.email) do
      nil ->
        binary = [%__MODULE__{user: user}] ++ get_accounts()
                 |> :erlang.term_to_binary()
        File.write(@accounts, binary)

        _ -> {:error, "Conta já cadastrada"}
    end
  end

  def get_accounts() do
    {:ok, binary} = File.read(@accounts)
    :erlang.binary_to_term(binary)
  end

  def get_accounts_by_email(email), do: Enum.find(get_accounts(), &(&1.user.email == email))

  def delete(delete_accounts) do
    Enum.reduce(delete_accounts, get_accounts(), fn c, acc -> List.delete(acc, c) end)
  end

  def transfer(from, to, value) do
    from = get_accounts_by_email(from)
    to = get_accounts_by_email(to)

    cond do
      validate_balance(from.balance, value) -> {:error, "Saldo insuficiente!"}

      true ->
        accounts = Account.delete([from, to])
        from = %Account{from | balance: from.balance - value}
        to = %Account{to | balance: to.balance + value}

        accounts = accounts ++ [from, to]

        File.write(@accounts, :erlang.term_to_binary(accounts))
    end
  end

  def withdraw(account, value) do
    account = get_accounts_by_email(account)

    cond do
      validate_balance(account.balance, value) -> {:error, "Saldo insuficiente!"}

      true ->
        accounts = Account.delete([account])
        account = %Account{account | balance: account.balance - value}

        accounts = accounts ++ [account]

        File.write(@accounts, :erlang.term_to_binary(accounts))
        {:ok, account, "mensagem de email encaminhada!"}
    end
  end

  defp validate_balance(balance, value), do: balance < value

end
