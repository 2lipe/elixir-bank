defmodule User do

  defstruct name: nil, email: nil

  def new_user(name, email), do: %__MODULE__{name: name, email: email}

end
