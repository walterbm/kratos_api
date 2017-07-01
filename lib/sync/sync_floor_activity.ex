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
    house: "http://docs.house.gov/billsthisweek/"
  }

  @mapping %{
    senate: [{:on_the_floor, [
      ~x"///item"l,
      title: ~x"./name/text()"s,
      senate_bill: ~x"./senate/article/text()"s,
      house_bill: ~x"./house/article/text()"s,
    ]}],
    house: [{:on_the_floor, [
      ~x"//floor-item"l,
      title: ~x"./floor-text/text()"s,
      bill_number: ~x"./legis-num/text()"s,
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
    Map.get(@congress_on_the_floor_source, :senate) <> "#{current_congress()}.xml"
  end
  defp url(:house) do
    Map.get(@congress_on_the_floor_source, :house) <> "#{current_monday()}/#{current_monday()}.xml"
  end

  defp current_congress do
    CongressNumber.current()
  end

  defp current_monday do
    Timex.today
    |> Timex.beginning_of_week
    |> Date.to_string
    |> String.replace("-", "")
  end

  defp stage(:house, %{title: title, bill_number: bill_number}) do
    %{
      active: true,
      title: title,
      chamber: "house",
      bill_id: get_bill(bill_number),
      md5: SyncHelpers.gen_md5(bill_number)
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

  defp save(params) do
    changeset = FloorActivity.changeset(%FloorActivity{}, params)
    SyncHelpers.save(changeset, [md5: changeset.changes.md5])
  end

end
