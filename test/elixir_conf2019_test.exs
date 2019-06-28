defmodule ElixirConf2019Test do
  use ExUnit.Case
  doctest ElixirConf2019

  test "" do
    assert ElixirConf2019.hello() == :world
  end
end
