defmodule KratosApi.Sync.Floor do
  import SweetXml

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @congress_on_the_floor_source %{
    senate: "https://www.congress.gov/rss/senate-floor-today.xml",
    house: "http://clerk.house.gov/floorsummary/floor-rss.ashx"
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
      title: ~x"./title/text()"s,
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
    Map.get(@congress_on_the_floor_source, chamber)
  end

  def save(record) do
    IO.inspect record
  end

end
