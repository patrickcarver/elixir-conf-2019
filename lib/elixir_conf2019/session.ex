defmodule ElixirConf2019.Session do
  @moduledoc """
  Struct used for storing collected data for a session.
  """

  alias Floki

  alias ElixirConf2019.Processing.{Selectors, SpeakerLinks}

  defstruct ~w[speaker company audience topic title github twitter]a

  def new(opts) do
    struct!(__MODULE__, opts)
  end

  def parse(html) do
    html
    |> Floki.parse()
    |> Selectors.process()
    |> SpeakerLinks.process()
    |> new()
  end
end
