defmodule KratosApi.Sync.Floor do
  import SweetXml

  alias KratosApi.{
    Repo,
    Bill,
    SyncHelpers,
    FloorActivity,
    CongressNumber,
  }

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @congress_on_the_floor_source %{
    senate: "https://www.senate.gov/reference/active_bill_type/",
    house: "http://clerk.house.gov/floorsummary/floor-rss.ashx" # or http://docs.house.gov/billsthisweek/20170626/20170626.xml ?
  }

  @mapping %{
    senate: [{:on_the_floor, [
      ~x"///item"l,
      title: ~x"./name/text()"s,
      senate_bill: ~x"./senate/article/text()"s,
      house_bill: ~x"./house/article/text()"s,
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
    sync(:senate)
    sync(:house)
  end

  def sync(chamber) do
    pre_sync(chamber)

    @remote_scrape.scrape(:xml, url(chamber), Map.get(@mapping, chamber))
    |> Map.get(:on_the_floor)
    |> Enum.map(&(stage(chamber, &1)))
    |> Enum.each(&save/1)
  end

  defp pre_sync(:senate) do
    FloorActivity.delete_all("senate")
  end
  defp pre_sync(_), do: nil

  defp url(:senate) do
    Map.get(@congress_on_the_floor_source, :senate) <> "#{current_congress()}" <> ".xml"
  end
  defp url(chamber) do
    Map.get(@congress_on_the_floor_source, chamber)
  end

  defp current_congress do
    CongressNumber.current()
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

  defp stage(:senate, %{title: title, senate_bill: senate_bill, house_bill: house_bill}) do
    bill_number = if byte_size(senate_bill) == 0 do house_bill else senate_bill end
    %{
      active: true,
      title: title,
      chamber: "senate",
      bill_id: get_bill(bill_number),
      published_at: Ecto.DateTime.utc(),
      md5: SyncHelpers.gen_md5(bill_number)
    }
  end

  defp get_bill(bill_number) do
    gpo_id =
      bill_number
      |> String.trim
      |> String.downcase
      |> String.replace(".", "")
      |> String.replace(" ", "")
      |> Kernel.<>("-#{current_congress()}")

    case Repo.get_by(Bill, gpo_id: gpo_id) do
      nil -> nil
      bill -> bill.id
    end
  end

  defp guid_to_datetime(guid) do
    String.slice(guid, 0, 4) <> "-" <> String.slice(guid, 4, 2) <> "-" <> String.slice(guid, 6, byte_size(guid)) <> "-04:00"
    |> SyncHelpers.convert_datetime("ISO:Extended")
  end

  defp save(params) do
    changeset = FloorActivity.changeset(%FloorActivity{}, params)
    SyncHelpers.save(changeset, [md5: changeset.changes.md5])
  end

end
