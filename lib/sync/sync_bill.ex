defmodule KratosApi.Sync.Bill do

  alias KratosApi.{
    Repo,
    Bill,
    Person,
    Subject,
    Committee,
    CongressNumber,
    RelatedBill,
    SyncHelpers
  }

  @remote_queue Application.get_env(:kratos_api, :remote_queue)

  def sync do
    @remote_queue.fetch_queue("congress-bills") |> Enum.map(&save/1)
  end

  defp save(raw_message) do
    unless KratosApi.Repo.get_by(Bill, md5_of_body: raw_message.md5_of_body) do
      case Poison.decode(raw_message.body) do
        {:ok, data} ->
          params = prepare(data, raw_message)
          changeset = Bill.changeset(%Bill{}, params) |> add_associations(data)
          SyncHelpers.save(changeset, [gpo_id: data["bill_id"]])
        {:error, message} -> message
      end
    end
  end

  defp prepare(data, raw_message) do
    %{
      actions: Enum.sort(data["actions"], &(&1["acted_at"] >= &2["acted_at"])),
      amendments: data["amendments"],
      gpo_id: data["bill_id"],
      type: data["bill_type"],
      committee_history: data["committees"],
      enacted_as: data["enacted_as"],
      active: data["history"]["active"],
      awaiting_signature: data["history"]["awaiting_signature"],
      enacted: data["history"]["enacted"],
      vetoed: data["history"]["vetoed"],
      history: data["history"],
      introduced_at: SyncHelpers.convert_date(data["introduced_at"]),
      number: data["number"],
      official_title: data["official_title"],
      popular_title: data["popular_title"],
      short_title: data["short_title"],
      status: data["status"],
      status_at: SyncHelpers.convert_datetime(data["status_at"]),
      top_term: data["subjects_top_term"],
      summary_text: data["summary"]["text"],
      summary_date: SyncHelpers.convert_datetime(data["summary"]["date"]),
      titles: data["titles"],
      gpo_data_updated_at: SyncHelpers.convert_datetime(data["updated_at"]),
      source_url: data["url"],
      md5_of_body: raw_message.md5_of_body
    }
  end

  defp add_associations(changeset, data) do
    congress_number = CongressNumber.find_or_create(elem(Integer.parse(data["congress"]),0))
    sponsor = Repo.get_by(Person, bioguide: data["sponsor"]["bioguide_id"])
    committees =
      Enum.map(data["committees"], &(Repo.get_by(Committee, thomas_id: &1["committee_id"])))
      |> Enum.reject(&(is_nil(&1)))
    subjects = Enum.map(data["subjects"], &(Subject.find_or_create(&1)))
    cosponsors =
      Enum.map(data["cosponsors"],&(Repo.get_by(Person, bioguide: &1["bioguide_id"])))
      |> Enum.reject(&(is_nil(&1)))
    related_bills =
      Enum.map(data["related_bills"], &(RelatedBill.create(&1)))
      |> Enum.reject(&(is_nil(&1)))

    changeset
      |> SyncHelpers.apply_assoc(:congress_number, congress_number)
      |> SyncHelpers.apply_assoc(:sponsor, sponsor)
      |> SyncHelpers.apply_assoc(:committees, committees)
      |> SyncHelpers.apply_assoc(:cosponsors, cosponsors)
      |> SyncHelpers.apply_assoc(:subjects, subjects)
      |> SyncHelpers.apply_assoc(:related_bills, related_bills)
  end
end
