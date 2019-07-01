defmodule ElixirConf2019.Processing.SpeakerLinks do
  @moduledoc """
  Extracts github and twitter links from session page
  """

  alias Floki

  defstruct ~w[github twitter]a

  def new do
    %__MODULE__{}
  end

  def process(token) do
    token
    |> find()
    |> set()
  end

  defp find(token) do
    new_parsed = create_list_of_links(token)
    %{token | parsed: new_parsed}
  end

  defp set(token) do
    new_speaker_links = create_speaker_links(token)
    %{token | speaker_links: new_speaker_links}
  end

  defp create_list_of_links(token) do
    token.parsed
    |> Floki.find(".w-full.flex.justify-around a")
    |> Floki.attribute("href")
    |> Enum.reject(fn url -> url in ~w[/2019#venue /2019/policies] end)
  end

  defp create_speaker_links(token) do
    Enum.reduce(token.parsed, token.speaker_links, fn url, speaker_links ->
      cond do
        github?(url) ->
          %{speaker_links | github: url}
        twitter?(url) ->
          %{speaker_links | twitter: url}
        true ->
          speaker_links
      end
    end)
  end

  defp github?(url) do
    String.starts_with?(url, "https://github.com")
  end

  defp twitter?(url) do
    String.starts_with?(url, "https://twitter.com")
  end
end
