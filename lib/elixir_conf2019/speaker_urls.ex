defmodule ElixirConf2019.SpeakerUrls do
  @moduledoc """
  Create list of links to session pages
  """

  alias Floki

  def parse(html) do
    html
    |> Floki.parse()
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.filter(fn url -> String.starts_with?(url, "/2019/speakers/") end)
  end
end
