defmodule ElixirConf2019.Sessions.Summary do
  @moduledoc """

  """

  import ElixirConf2019.Helpers

  def count(sessions, key) when key in ~w[audience company topic]a do
    sessions
    |> Enum.reduce(%{}, fn session, acc ->
      Map.update(acc, Map.get(session, key), 1, &(&1 + 1))
    end)
    |> ok_tuple()
  end

  def count(_session, key) do
    {:error, "Sorry, '#{key}' is not supported"}
  end

  def list(sessions, key) do
    sessions
    |> Enum.map(fn session -> Map.get(session, key) end)
    |> Enum.uniq()
    |> Enum.sort()
    |> ok_tuple()
  end
end
