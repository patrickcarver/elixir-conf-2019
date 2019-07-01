defmodule ElixirConf2019.Processing.Selectors do
  @moduledoc """
  Extract session data from page
  """

  alias Floki

  alias ElixirConf2019.Processing.Token

  def process(parsed) do
    acc = Token.new(parsed)
    Enum.reduce(selectors(), acc, fn {key, value}, token ->
      text = get_text(token.parsed, value)
      new_session = Map.put(token.session, key, text)
      %{token | session: new_session}
    end)
  end

  defp selectors do
    [
      {:speaker, ".text-center.text-4xl.font-bold.leading-tight.mt-2"},
      {:company, ".text-gray-dark.text-center.text-base"},
      {:audience, ".mt-4.text-orange-dark .font-medium"},
      {:topic, ".my-4.text-purple-dark .font-medium"},
      {:title, "h2"}
    ]
  end

  defp get_text(parsed, value) do
    parsed
    |> Floki.find(value)
    |> Floki.text()
    |> String.trim()
  end
end
