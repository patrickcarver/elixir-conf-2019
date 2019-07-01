defmodule ElixirConf2019.Processing.Token do
  @moduledoc """
  Token for storing data through processing pipeline
  """

  alias ElixirConf2019.Processing.SpeakerLinks
  alias ElixirConf2019.Session

  defstruct ~w[parsed session speaker_links]a

  def new(parsed) do
    %__MODULE__{
      parsed: parsed,
      session: Session.new(),
      speaker_links: SpeakerLinks.new()
    }
  end
end
