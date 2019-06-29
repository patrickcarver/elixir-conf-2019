defmodule ElixirConf2019 do
  @moduledoc """
  This module loads the Elixir Conf 2019 website, visits each link to each session page,
  and collects selected data.
  """

  alias HTTPoison

  alias ElixirConf2019.{Page, Session, SpeakerUrls}

  defp speaker_urls(url) do
    Page.parse(url, &SpeakerUrls.parse/1)
  end

  defp session_page(url) do
    Page.parse(url, &Session.parse/1)
  end

  defp sessions(speaker_urls) do
    speaker_urls
    |> Task.async_stream(&session_page/1)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  def run do
    "2019"
    |> speaker_urls()
    |> sessions()
  end
end
