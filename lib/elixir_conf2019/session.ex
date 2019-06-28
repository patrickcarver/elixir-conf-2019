defmodule ElixirConf2019.Session do
  defstruct ~w[speaker company audience topic title github twitter]a

  def new(opts) do
    struct!(__MODULE__, opts)
  end
end
