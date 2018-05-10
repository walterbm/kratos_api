defmodule KratosApi.Sync.Bill.Producer do
  use GenStage

  @remote_queue Application.get_env(:kratos_api, :remote_queue)

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, state) when demand > 0 do
    @remote_queue.dequeue("congress-bills", state)
    |> reply(state)
  end

  defp reply([], _state), do: {:stop, :normal, 0}
  defp reply(events, state), do: {:noreply, events, state + length(events)}
end

defmodule KratosApi.Sync.Bill.Processor do
  use GenStage

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

  def init(state) do
    {:producer_consumer, state}
  end

  def handle_events(events, _from, state) do
    events =
      Enum.map(events, &(process(&1)))
      |> Enum.reject(&(is_nil(&1)))
    {:noreply, events, state + length(events)}
  end

  defp process(raw_message) do
    case Repo.get_by(Bill, md5_of_body: raw_message.md5_of_body) do
      nil -> raw_message |> create_changeset
      _ -> nil
    end
  end

  defp create_changeset(raw_message) do
    case Poison.decode(raw_message.body) do
      {:ok, data} ->
        params = stage(data, raw_message)
        Bill.changeset(%Bill{}, params) |> add_associations(data)
      {:error, _message} -> raise SQSParseError
    end
  end

  defp stage(data, raw_message) do
    %{
      actions: Enum.sort(data["actions"], &(&1["acted_at"] >= &2["acted_at"])),
      amendments: data["amendments"],
      gpo_id: data["bill_id"],
      pretty_gpo: make_gpo_pretty(data["bill_id"]),
      type: data["bill_type"],
      committee_history: data["committees"],
      enacted_as: convert_enacted_as(data["enacted_as"]),
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
      summary_text: data["summary"]["text"],
      summary_date: SyncHelpers.convert_datetime(data["summary"]["date"]),
      titles: data["titles"],
      gpo_data_updated_at: SyncHelpers.convert_datetime(data["updated_at"]),
      source_url: data["url"],
      md5_of_body: raw_message.md5_of_body
    }
  end

  defp convert_enacted_as(nil), do: nil
  defp convert_enacted_as(enacted_as) when is_map(enacted_as), do: enacted_as
  defp convert_enacted_as(enacted_as) when is_binary(enacted_as), do: %{"law" => enacted_as}

  defp make_gpo_pretty(gpo_id) do
    [chamber | number] = Regex.run(~r/^([a-zA-Z]+)(\d+)-/, gpo_id, [capture: :all_but_first])
    chamber =
      chamber
      |> String.upcase
      |> String.split("", trim: true)
      |> Enum.join(".")

    "#{chamber}. #{number}"
  end

  defp add_associations(changeset, data) do
    congress_number = CongressNumber.find_or_create(data["congress"])
    sponsor = Repo.get_by(Person, bioguide: data["sponsor"]["bioguide_id"])
    top_subject = Subject.find_or_create(data["subjects_top_term"])
    subjects = Enum.map(data["subjects"], &(Subject.find_or_create(&1)))
    committees =
      Enum.map(data["committees"], &(Repo.get_by(Committee, thomas_id: &1["committee_id"])))
      |> Enum.reject(&(is_nil(&1)))
    cosponsors =
      Enum.map(data["cosponsors"],&(Repo.get_by(Person, bioguide: &1["bioguide_id"])))
      |> Enum.reject(&(is_nil(&1)))
    related_bills =
      Enum.map(data["related_bills"], &(RelatedBill.create(&1)))
      |> Enum.reject(&(is_nil(&1)))

    changeset
      |> SyncHelpers.apply_assoc(:congress_number, congress_number)
      |> SyncHelpers.apply_assoc(:sponsor, sponsor)
      |> SyncHelpers.apply_assoc(:top_subject, top_subject)
      |> SyncHelpers.apply_assoc(:committees, committees)
      |> SyncHelpers.apply_assoc(:cosponsors, cosponsors)
      |> SyncHelpers.apply_assoc(:subjects, subjects)
      |> SyncHelpers.apply_assoc(:related_bills, related_bills)
  end
end

defmodule KratosApi.Sync.Bill.Consumer do
  use GenStage

  alias KratosApi.{
    Repo,
    Bill,
    SyncHelpers
  }

  def init(:ok) do
    {:consumer, :the_state_does_not_matter}
  end

  def handle_events(events, _from, state) do
    Enum.map(events, &(save(&1)))
    {:noreply, [], state}
  end

  defp save(changeset) do
    SyncHelpers.save(changeset, [gpo_id: changeset.changes.gpo_id], &update/2)
  end

  defp update(record, changeset) do
    record
    |> Repo.preload([:related_bills, :tallies])
    |> Bill.update(changeset.changes)
  end
end
