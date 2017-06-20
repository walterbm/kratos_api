defmodule KratosApi.Sync.Floor do
  import SweetXml

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @congress_on_the_floor_source %{
    base_url: "https://www.congress.gov/rss/",
    senate: "senate-floor-today.xml",
    house: "house-floor-today.xml"
  }

  @mapping %{
    senate: [{:on_the_floor, [
      ~x"//item"l,
      guid: ~x"./title/text()"s,
      description: ~x"./description/text()"s,
      link: ~x"./link/text()"s,
    ]}],
    house: [{:on_the_floor, [
      ~x"//item"l,
      guid: ~x"./title/text()"s,
      description: ~x"./description/text()"s,
      link: ~x"./link/text()"s,
    ]}]
  }

  def sync() do
    sync(:senate)
    sync(:house)
  end

  def sync(chamber) do
    @remote_scrape.scrape(:xml, url(chamber), Map.get(@mapping, chamber))
    |> Map.get(:on_the_floor)
    |> Enum.each(&save/1)
  end

  def url(chamber) do
    "#{@congress_on_the_floor_source.base_url}#{Map.get(@congress_on_the_floor_source, chamber)}"
  end

  def save(record) do
    IO.inspect record
  end

end
