defmodule ElixirConf2019 do
  alias HTTPoison
  alias Floki

  alias ElixirConf2019.Session

  defp process_speaker_links(token) do
    token.parsed
    |> find_speaker_links()
    |> create_speaker_link_map()
    |> add_speaker_links(token.session)
  end

  defp add_speaker_links(links, session) do
    Map.merge(session, links)
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

  defp find_speaker_links(parsed) do
    parsed
    |> Floki.find(".w-full.flex.justify-around a")
    |> Floki.attribute("href")
    |> Enum.reject(fn url -> url in ~w[/2019#venue /2019/policies] end)
  end

  defp process_selector_list(parsed) do
    acc = %{parsed: parsed, session: %{}}
    Enum.reduce(selectors(), acc, fn {key, value}, token ->
      text = get_text(token.parsed, value)
      new_session = Map.put(token.session, key, text)
      %{token | session: new_session}
    end)
  end

  defp get_text(parsed, value) do
    parsed
    |> Floki.find(value)
    |> Floki.text()
    |> String.trim()
  end

  defp selectors() do
    [
      {:speaker, ".text-center.text-4xl.font-bold.leading-tight.mt-2"},
      {:company, ".text-gray-dark.text-center.text-base"},
      {:audience, ".mt-4.text-orange-dark .font-medium"},
      {:topic, ".my-4.text-purple-dark .font-medium"},
      {:title, "h2"}
    ]
  end

  defp parse_into_session(html) do
    html
    |> Floki.parse()
    |> process_selector_list()
    |> process_speaker_links()
    |> Session.new()
  end

  defp parse_into_speaker_urls(html) do
    html
    |> Floki.parse()
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.filter(fn url -> String.starts_with?(url, "/2019/speakers/") end)
  end

  defp load_page(ending, function) do
    case HTTPoison.get("https://elixirconf.com/" <> ending) do
      {:ok, %HTTPoison.Response{body: html}} ->
        function.(html)
      error ->
        error
    end
  end

  defp speaker_urls(url) do
    load_page(url, &parse_into_speaker_urls/1)
  end

  defp session_page(url) do
    load_page(url, &parse_into_session/1)
  end

  defp sessions(speaker_urls) do
    speaker_urls
    |> Task.async_stream(&session_page/1)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  def run() do
    "2019"
    |> speaker_urls()
    |> sessions()
  end
end
