defmodule KratosApi.ConfigConverter do
  @usage """
  USAGE: elixir_to_sys_config prod.exs > sys.config
  Generate Erlang-style sys.config from Elixir-style prod.exs
  """

  def convert(path) do
    convert(path, File.exists?(path))
  end

  defp convert(path, false) do
    msg = "Error: Could not find #{inspect path}\n\n" <> @usage
    IO.inspect msg
    {:error, msg}
  end

  defp convert(path, true) do
    config = Mix.Config.read!(path)
    converted_config = :io_lib.format('~p.~n', [config]) |> List.to_string
    File.write("./config/#{Mix.env}.sys.config", converted_config)
  end
end
