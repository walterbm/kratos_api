defmodule Mix.Tasks.Prep.Stage do
  use Mix.Task

  def run(_) do
    Mix.env(:stage)
    KratosApi.ConfigConverter.convert("config/config.exs")
  end
end

defmodule Mix.Tasks.Prep.Prod do
  use Mix.Task

  def run(_) do
    Mix.env(:prod)
    KratosApi.ConfigConverter.convert("config/config.ex")
  end
end
