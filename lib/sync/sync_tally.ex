defmodule KratosApi.Sync.Tally do

  alias KratosApi.{
    SyncHelpers,
    CongressNumber,
    Nomination,
    Bill,
    Tally,
    Vote,
    Repo
  }

  @remote_queue Application.get_env(:kratos_api, :remote_queue)

  @chambers %{"s" => "Senate", "h" => "House"}

  def sync do
    @remote_queue.fetch_queue("congress-votes") |> Enum.map(&save/1)
  end

  defp save(raw_message) do
    unless Repo.get_by(Tally, md5_of_body: raw_message.md5_of_body) do
      case Poison.decode(raw_message.body) do
        {:ok, data} ->
          params = prepare(data, raw_message)
          changeset = Tally.changeset(%Tally{}, params) |> add_associations(data)
          SyncHelpers.save(changeset, [gpo_id: data["vote_id"]])
        {:error, message} -> message
      end
    end
  end

  defp prepare(data, raw_message) do
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
      gpo_id: extract_gpo_id(data["bill"]),
      bill_short_title: get_bill_attribute(data, :short_title),
      bill_official_title: get_bill_attribute(data, :official_title),
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
