defmodule ElixirConf2019.Processing.SpeakerLinks do
  @moduledoc """
  """

  alias Floki

  def process(token) do
    token.parsed
    |> find_speaker_links()
    |> create_speaker_link_map()
    |> add_speaker_links(token.session)
  end

  defp find_speaker_links(parsed) do
    parsed
    |> Floki.find(".w-full.flex.justify-around a")
    |> Floki.attribute("href")
    |> Enum.reject(fn url -> url in ~w[/2019#venue /2019/policies] end)
  end

  defp create_speaker_link_map(list) do
    Enum.reduce(list, %{github: nil, twitter: nil}, fn url, acc ->
      cond do
        github?(url) ->
          %{acc | github: url}
        twitter?(url) ->
          %{acc | twitter: url}
        true ->
          acc
      end
    end)
  end

  defp github?(url) do
    String.starts_with?(url, "https://github.com")
  end

  defp twitter?(url) do
    String.starts_with?(url, "https://twitter.com")
  end

  defp add_speaker_links(links, session) do
    Map.merge(session, links)
  end
end
