defmodule KratosApi.Sync.Floor do
  import SweetXml

  alias KratosApi.{
    SyncHelpers,
    FloorActivity
  }

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @congress_on_the_floor_source %{
    senate: "https://www.congress.gov/rss/senate-floor-today.xml", # is this the best source for the senate?
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
      guid: ~x"./guid/text()"s,
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

  defp stage(:house, %{title: title, description: description, link: link, guid: guid}) do
    %{
      link: link,
      title: title,
      chamber: "house",
      description: description,
      published_at: guid_to_datetime(guid),
      md5: SyncHelpers.gen_md5(title <> description)
    }
  end

  def guid_to_datetime(guid) do
    String.slice(guid, 0, 4) <> "-" <> String.slice(guid, 4, 2) <> "-" <> String.slice(guid, 6, byte_size(guid)) <> "-04:00"
    |> KratosApi.SyncHelpers.convert_datetime("ISO:Extended")
  end

  defp save(params) do
    changeset = FloorActivity.changeset(%FloorActivity{}, params)
    SyncHelpers.save(changeset, [md5: changeset.changes.md5])
  end

end
