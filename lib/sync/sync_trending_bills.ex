defmodule KratosApi.Sync.TrendingBill do
  import SweetXml

  alias KratosApi.{
    Repo,
    Bill,
    SyncHelpers,
    TrendingBill,
  }

  @remote_scrape Application.get_env(:kratos_api, :remote_scraper)

  @sources %{
    congress_dot_gov: "https://www.congress.gov/rss/most-viewed-bills.xml",
  }

  @base %{
    congress_dot_gov: ~x"///item/description/text()",
  }

  @mapping %{
    congress_dot_gov: [{:trending, [
      ~x"///ol/li"l,
      bill: ~x"./a/text()"s,
      link: ~x"./a/@href"s,
    ]}]
  }

  def sync() do
    sync(:congress_dot_gov)
  end

  def sync(source) do
    pre_sync(source)
    @remote_scrape.scrape(:xml, url(source), Map.get(@base, source), Map.get(@mapping, source))
    |> Map.get(:trending)
    |> Enum.map(&(stage(source, &1)))
    |> Enum.each(&save/1)
  end

  defp pre_sync(source) do
    TrendingBill.delete_all(to_string(source))
  end

  defp url(source) do
    Map.get(@sources, source)
  end

  defp stage(:congress_dot_gov, %{bill: bill, link: link}) do
    %{
      source: to_string(:congress_dot_gov),
      bill_id: get_bill(bill, link),
      md5: SyncHelpers.gen_md5(to_string(:congress_dot_gov) <> to_string(bill))
    }
  end

  defp get_bill_gpo_id(bill_number, congress_number) do
    bill_number
    |> String.trim
    |> String.downcase
    |> String.replace(".", "")
    |> String.replace(" ", "")
    |> Kernel.<>("-#{congress_number}")
  end

  defp get_bill(bill, link) do
    link = to_string(link)
    bill = to_string(bill)
    [_match, congress_number] = Regex.run(~r/bill\/([0-9]+)/, link)
    gpo_id = get_bill_gpo_id(bill, congress_number)

    case Repo.get_by(Bill, gpo_id: gpo_id) do
      nil -> nil
      bill -> bill.id
    end
  end

  defp save(params) do
    changeset = TrendingBill.changeset(%TrendingBill{}, params)
    SyncHelpers.save(changeset, [md5: changeset.changes.md5])
  end

end
