defmodule ElixirConf2019.Page do
  @moduledoc """
  Load page and invoke function to parse
  """

  alias HTTPoison

  def parse(ending, function) do
    case HTTPoison.get("https://elixirconf.com/" <> ending) do
      {:ok, %HTTPoison.Response{body: html}} ->
        function.(html)
      error ->
        error
    end
  end
end
