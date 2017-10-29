defmodule KratosApi.RemoteScrape do

  @invalid_xml_chars ~r/[&]/

  def scrape(url, tag), do: scrape(:html, url, tag)
  def scrape(:html, url, tag) do
    get(url)
    |> Floki.find(tag)
  end
  def scrape(:xml, url, mapping) do
    get(url)
    |> IO.inspect
    # |> parse(mapping)
  end
  def scrape(:xml, url, base, mapping) do
    get(url)
    |> parse(base, mapping)
  end

  def parse(string, mapping) do
    string
    |> SweetXml.parse
    |> SweetXml.xmap(mapping)
  end
  def parse(string, base, mapping) do
    string
    |> SweetXml.parse
    |> SweetXml.xpath(base)
    |> to_string
    |> String.replace(@invalid_xml_chars, "")
    |> SweetXml.parse
    |> SweetXml.xmap(mapping)
  end

  defp get(url) do
    HTTPoison.get!(url, [], hackney: [:insecure])
    |> Map.get(:body)
  end

end
