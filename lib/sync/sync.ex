defmodule KratosApi.SyncHelpers do

  def apply_assoc(changeset, _, nil), do: changeset
  def apply_assoc(changeset, field, data), do: Ecto.Changeset.put_assoc(changeset, field, data)

  def convert_date(date_as_string), do: convert_date_or_datetime(date_as_string, Date)

  def convert_datetime(date_as_string), do: convert_date_or_datetime(date_as_string, NaiveDateTime)

  defp convert_date_or_datetime(date_as_string, date_module) do
    unless is_nil(date_as_string) do
      case date_module.from_iso8601(date_as_string) do
        {:ok, date} -> date
        {:error, _} -> nil
      end
    end
  end

  def save(changeset) do
    result =
      case KratosApi.Repo.get_by(changeset.data.__struct__, govtrack_id: changeset.changes.govtrack_id) do
        nil  ->
          KratosApi.Repo.insert(changeset)
        record ->
          changes = changeset.data.__struct__.changeset(record, changeset.changes)
          KratosApi.Repo.update(changes)
      end

    case result do
      {:ok, record}       -> record
      {:error, changeset} -> changeset.errors
    end
  end

  def save(changeset, kargs) do
    result =
      case KratosApi.Repo.get_by(changeset.data.__struct__, kargs) do
        nil  ->
          KratosApi.Repo.insert(changeset)
        record ->
          changes = changeset.data.__struct__.changeset(record, changeset.changes)
          KratosApi.Repo.update(changes)
      end

    case result do
      {:ok, record}       -> record
      {:error, changeset} ->
        changeset.errors
    end
  end

end

defmodule KratosApi.Sync.Role do
  alias KratosApi.Role
  alias KratosApi.SyncHelpers

  @govtrack_api Application.get_env(:kratos_api, :govtrack_api)

  def sync do
    response = @govtrack_api.roles([current: true, limit: 6000])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = @govtrack_api.role([current: true, id: id])
    save(response)
  end

  def save(data) do
    params = prepare(data)
    changeset = Role.changeset(%Role{}, params) |> add_associations(data)
    SyncHelpers.save(changeset)
  end

  def prepare (data) do
    %{
      current: data["current"],
      enddate: SyncHelpers.convert_date(data["enddate"]),
      description: data["description"],
      govtrack_id: data["id"],
      caucus: data["caucus"],
      district: data["district"],
      extra: data["extra"],
      leadership_title: data["leadership_title"],
      party: data["party"],
      phone: data["phone"],
      role_type: data["role_type"],
      role_type_label: data["role_type_label"],
      senator_class: data["senator_class"],
      senator_class_label: data["senator_class_label"],
      senator_rank: data["senator_rank"],
      senator_rank_label: data["senator_rank_label"],
      startdate: SyncHelpers.convert_date(data["startdate"]),
      state: data["state"],
      title: data["title"],
      title_long: data["title_long"],
      website: data["website"]
    }
  end

  def add_associations(changeset, data) do
    congress_numbers = Enum.map(data["congress_numbers"], &(KratosApi.CongressNumber.find_or_create(&1)))
    person = KratosApi.Person.find_or_create(data["person"])

    changeset
      |> SyncHelpers.apply_assoc(:congress_numbers, congress_numbers)
      |> SyncHelpers.apply_assoc(:person, person)
  end
end

defmodule KratosApi.Sync.Person do
  alias KratosApi.Person
  alias KratosApi.SyncHelpers

  def sync do
    response = Govtrack.persons([limit: 6000])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = Govtrack.person([id: id])
    save(response["objects"])
  end

  def save(data) do
    params = prepare(data)
    changeset = Person.changeset(%Person{}, params)
    SyncHelpers.save(changeset)
  end

  def prepare (data) do
    extract_party_and_state = ~r/\[(?<party>[A-Z])-(?<state>\w+)/

    %{
      govtrack_id: data["id"],
      bioguideid: data["bioguideid"],
      birthday: SyncHelpers.convert_date(data["birthday"]),
      cspanid: data["cspanid"],
      firstname: data["firstname"],
      gender: data["gender"],
      gender_label: data["gender_label"],
      lastname: data["lastname"],
      link: data["link"],
      middlename: data["middlename"],
      name: data["name"],
      current_party: Regex.named_captures(extract_party_and_state, data["name"])["party"],
      current_state: Regex.named_captures(extract_party_and_state, data["name"])["state"],
      namemod: data["namemod"],
      nickname: data["nickname"],
      osid: data["osid"],
      pvsid: data["pvsid"],
      sortname: data["sortname"],
      twitterid: data["twitterid"],
      youtubeid: data["youtubeid"],
      image_url: "#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{data["bioguideid"]}.jpg"
    }
  end
end

defmodule KratosApi.Sync.Committee do
  alias KratosApi.Committee
  alias KratosApi.SyncHelpers

  @govtrack_api Application.get_env(:kratos_api, :govtrack_api)

  @committee_types %{"S" => "Senate", "J" => "Joint", "H" => "House"}

  def sync do
    response = @govtrack_api.committees([limit: 6000])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = @govtrack_api.committee([id: id])
    save(response)
  end

  def save(data) do
    params = prepare(data)
    changeset = Committee.changeset(%Committee{}, params) |> add_associations(data)
    SyncHelpers.save(changeset)
  end

  def prepare (data) do
    %{
      abbrev: data["abbrev"],
      code: data["code"],
      committee_type: data["committee_type"],
      govtrack_id: data["id"],
      jurisdiction: data["jurisdiction"],
      jurisdiction_link: data["jurisdiction_link"],
      name: data["name"],
      obsolete: data["obsolete"],
      url: data["url"],
      committee_type: String.downcase(@committee_types[String.first(data["code"])]),
      committee_type_label: @committee_types[String.first(data["code"])],
    }
  end

  def add_associations(changeset, data) do
    parent =
      case data["committee"]["id"] do
        nil -> nil
        _ -> Committee.find_or_create(data["committee"])
      end

    changeset
      |> SyncHelpers.apply_assoc(:parent, parent)
  end
end

defmodule KratosApi.Sync.Bill do
  alias KratosApi.Bill
  alias KratosApi.SyncHelpers

  @remote_queue Application.get_env(:kratos_api, :remote_queue)

  def sync do
    @remote_queue.fetch_queue("congress-bills") |> Enum.map(&save/1)
  end

  def save(raw_message) do
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

  def prepare(data, raw_message) do
    %{
      actions: data["actions"],
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
      status_at: SyncHelpers.convert_date(data["status_at"]),
      top_term: data["subjects_top_term"],
      summary_text: data["summary"]["text"],
      summary_date: SyncHelpers.convert_datetime(data["summary"]["date"]),
      titles: data["titles"],
      gpo_data_updated_at: SyncHelpers.convert_datetime(data["updated_at"]),
      md5_of_body: raw_message.md5_of_body
    }
  end

  def add_associations(changeset, data) do
    congress_number = KratosApi.CongressNumber.find_or_create(elem(Integer.parse(data["congress"]),0))
    sponsor = KratosApi.Repo.get_by(KratosApi.Person, bioguideid: data["sponsor"]["bioguide_id"])
    committees =
      Enum.map(data["committees"], &(KratosApi.Repo.get_by(KratosApi.Committee, code: &1["committee_id"])))
      |> Enum.reject(&(is_nil(&1)))
    subjects = Enum.map(data["subjects"], &(KratosApi.Subject.find_or_create(&1)))
    cosponsors =
      Enum.map(data["cosponsors"],&(KratosApi.Repo.get_by(KratosApi.Person, bioguideid: &1["bioguide_id"])))
      |> Enum.reject(&(is_nil(&1)))
    related_bills =
      Enum.map(data["related_bills"], &(KratosApi.RelatedBill.create(&1)))
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

  def save(raw_message) do
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

  def prepare(data, raw_message) do
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
      gpo_id: data["vote_id"],
      md5_of_body: raw_message.md5_of_body
    }
  end

  def add_associations(changeset, data) do
    congress_number = CongressNumber.find_or_create(data["congress"])
    bill = if data["bill"], do: Repo.get_by(Bill, gpo_id: "#{data["bill"]["type"]}#{data["bill"]["number"]}-#{data["bill"]["congress"]}")
    nomination = if data["nomination"], do: Nomination.create(data["nomination"])
    votes = Vote.mass_create(data["votes"])

    changeset
      |> SyncHelpers.apply_assoc(:congress_number, congress_number)
      |> SyncHelpers.apply_assoc(:bill, bill)
      |> SyncHelpers.apply_assoc(:nomination, nomination)
      |> SyncHelpers.apply_assoc(:votes, votes)

  end

end
