defmodule KratosApi.RemoteScrape do

  def scrape(url, tag) do
    HTTPoison.get!(url, [], hackney: [:insecure])
    |> Map.get(:body)
    |> Floki.find(tag)
  end

end
