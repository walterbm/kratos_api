defmodule KratosApi.Sync.Tally.Producer do
  use GenStage

  @remote_queue Application.get_env(:kratos_api, :remote_queue)

  def init(state) do
    {:producer, state}
  end

  def handle_demand(demand, state) when demand > 0 do
    @remote_queue.dequeue("congress-votes", state)
    |> reply(state)
  end

  defp reply([], _state), do: {:stop, :normal, 0}
  defp reply(events, state), do: {:noreply, events, state + length(events)}
end

defmodule KratosApi.Sync.Tally.Processor do
  use GenStage

  alias KratosApi.{
    SyncHelpers,
    CongressNumber,
    Nomination,
    Bill,
    Tally,
    Vote,
    Repo
  }

  @chambers %{"s" => "Senate", "h" => "House"}

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
    case Repo.get_by(Tally, md5_of_body: raw_message.md5_of_body) do
      nil -> raw_message |> create_changeset
      _ -> nil
    end
  end

  defp create_changeset(raw_message) do
    case Poison.decode(raw_message.body) do
      {:ok, data} ->
        params = stage(data, raw_message)
        Tally.changeset(%Tally{}, params) |> add_associations(data)
      {:error, _message} -> raise SQSParseError
    end
  end

  defp stage(data, raw_message) do
    %{
      amendment: Map.get(data, "amendment", nil),
      treaty: Map.get(data, "treaty", nil),
      category: Map.get(data, "category", nil),
      chamber: Map.get(@chambers, data["chamber"], nil),
      date: Map.get(data, "date", nil)  |> SyncHelpers.convert_datetime,
      number: Map.get(data, "number", nil),
      question: Map.get(data, "question", nil),
      requires: Map.get(data, "requires", nil),
      result: Map.get(data, "result", nil),
      result_text: Map.get(data, "result_text", nil),
      session: Map.get(data, "session", nil),
      source_url: Map.get(data, "source_url", nil),
      subject: Map.get(data, "subject", nil),
      type: Map.get(data, "type", nil),
      updated_at: Map.get(data, "updated_at", nil) |> SyncHelpers.convert_datetime,
      gpo_id: Map.get(data, "vote_id"),
      bill_short_title: get_bill_attribute(data, :short_title),
      bill_official_title: get_bill_attribute(data, :official_title),
      bill_pretty_gpo: get_bill_attribute(data, :pretty_gpo),
      md5_of_body: raw_message.md5_of_body
    }
  end

  defp extract_gpo_id(nil), do: nil
  defp extract_gpo_id(data), do: "#{data["type"]}#{data["number"]}-#{data["congress"]}"

  defp get_bill(nil), do: nil
  defp get_bill(gpo_id), do: Repo.get_by(Bill, gpo_id: gpo_id)

  defp get_bill_attribute(data, attribute) do
    case extract_gpo_id(data["bill"]) |> get_bill do
      nil -> nil
      bill -> Map.get(bill, attribute)
    end
  end

  defp add_associations(changeset, data) do
    congress_number = CongressNumber.find_or_create(data["congress"])
    bill = extract_gpo_id(data["bill"]) |> get_bill
    nomination = if data["nomination"], do: Nomination.create(data["nomination"])
    votes = Vote.mass_create(data["votes"])

    changeset
      |> SyncHelpers.apply_assoc(:congress_number, congress_number)
      |> SyncHelpers.apply_assoc(:bill, bill)
      |> SyncHelpers.apply_assoc(:nomination, nomination)
      |> SyncHelpers.apply_assoc(:votes, votes)
  end
end

defmodule KratosApi.Sync.Tally.Consumer do
  use GenStage

  alias KratosApi.{
    Tally,
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
    changeset |> SyncHelpers.save([gpo_id: changeset.changes.gpo_id], &update/2)
  end

  defp update(record, changeset) do
    Tally.update(record, changeset.changes)
  end


end
