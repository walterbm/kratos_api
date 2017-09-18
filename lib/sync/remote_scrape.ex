defmodule KratosApi.RemoteScrape do

  def scrape(url, tag), do: scrape(:html, url, tag)
  def scrape(:html, url, tag) do
    HTTPoison.get!(url, [], hackney: [:insecure])
    |> Map.get(:body)
    |> Floki.find(tag)
  end
  def scrape(:xml, url, mapping) do
    HTTPoison.get!(url, [])
    |> Map.get(:body)
    |> SweetXml.parse
    |> SweetXml.xmap(mapping)
  end
  def scrape(:xml, url, base, mapping) do
    HTTPoison.get!(url, [])
    |> Map.get(:body)
    |> SweetXml.parse
    |> SweetXml.xpath(base)
    |> SweetXml.parse
    |> SweetXml.xmap(mapping)
  end

end
