defmodule ElixirConf2019.Sessions.Summary do
  @moduledoc """

  """

  def count(sessions, key) when key in ~w[audience company topic]a do
    sessions
    |> Enum.reduce(%{}, fn session, acc ->
      Map.update(acc, Map.get(session, key), 1, &(&1 + 1))
    end)
  end

  def count(_session, _key) do
    []
  end

  defp breakup_keys(map) do
    Enum.map(map, fn {key, value} = element ->
      if String.contains?(key, ", ") do
        key
        |> String.split(", ")
        |> Enum.map(fn new_key -> {new_key, value} end)
      else
        element
      end
    end)
    |> List.flatten()
  end

  defp consolidate(list) do
    Enum.reduce(list, %{}, fn {key, value}, acc ->
      if Map.has_key?(acc, key) do
        Map.update!(acc, key, &(&1 + value))
      else
        Map.put(acc, key, value)
      end
    end)
  end

  def audience(sessions) do
    sessions
    |> count(:audience)
    |> breakup_keys()
    |> consolidate()
  end

  def list(sessions, key) do
    sessions
    |> Enum.map(fn session -> Map.get(session, key) end)
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.reject(&is_nil/1)
  end
end
