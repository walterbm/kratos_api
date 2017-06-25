defmodule KratosApi.Sync.Floor do
  import SweetXml

  alias KratosApi.{
    Repo,
    SyncHelpers,
    FloorActivity
  }

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
      day: ~x"./pubDate/text()"s,
    ]}]
  }

  def sync() do
    # sync(:senate)
    sync(:house)
  end

  def sync(chamber) do
    @remote_scrape.scrape(:xml, url(chamber), Map.get(@mapping, chamber))
    |> Map.get(:on_the_floor)
    |> Enum.map(&(stage(chamber, &1)))
    |> Enum.each(&save/1)
  end

  defp url(chamber) do
    Map.get(@congress_on_the_floor_source, chamber)
  end

  defp stage(:house, %{title: title, description: description, link: link, day: day}) do
    %{
      link: link,
      title: title,
      chamber: "house",
      description: description,
      published_at: SyncHelpers.convert_datetime(day, "RFC1123"),
      md5: SyncHelpers.gen_md5(title <> description)
    }
  end

  defp save(params) do
    FloorActivity.changeset(%FloorActivity{}, params)
    |> Repo.insert!
  end

end
