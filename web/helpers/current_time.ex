defmodule KratosApi.Time do
  def current() do
    {mega, secs, _} = :os.timestamp()
    mega * 1_000_000 + secs
  end
end
