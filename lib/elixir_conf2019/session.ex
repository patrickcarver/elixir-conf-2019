defmodule ElixirConf2019.Session do
  @moduledoc """
  Struct used for storing collected data for a session.
  """

  alias Floki

  alias ElixirConf2019.Processing.{Selectors, SpeakerLinks, Token}

  defstruct ~w[speaker company audience topic title github twitter]a

  def new do
    %__MODULE__{}
  end

  def parse(html) do
    html
    |> Floki.parse()
    |> Selectors.process()
    |> SpeakerLinks.process()
    |> add_speaker_links()
  end

  defp add_speaker_links(%Token{} = token) do
    Enum.reduce(token.speaker_links, token.session, fn {key, value}, session ->
      Map.put(session, key, value)
    end)
  end
end
