defmodule ElixirConf2019.Session do
  @moduledoc """
  Struct used for storing collected data for a session.
  """

  alias Floki

  alias ElixirConf2019.Processing.{Selectors, SpeakerLinks, Token}

  defstruct ~w[speaker company audience topic title github twitter]a

  def keys do
    %Session{}
  end

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
    token.session
    |> Map.put(:github, token.speaker_links.github)
    |> Map.put(:twitter, token.speaker_links.twitter)
  end
end
