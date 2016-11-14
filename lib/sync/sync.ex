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
    case KratosApi.Repo.insert(changeset) do
      {:ok, record} ->
        record
      {:error, changeset} ->
        changeset.errors
    end
  end

end

defmodule KratosApi.Sync.Role do
  alias KratosApi.Role
  alias KratosApi.SyncHelpers

  def sync do
    response = Govtrack.roles([current: true, limit: 1])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = Govtrack.role([current: true, id: id])
    save(response["objects"])
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
      govtrack_id: data["person"]["id"],
      caucus: data["caucus"],
      district: data["district"],
      extra: data["extra"],
      leadership_title: data["leadership_title"],
      party: data["party"],
      bioguideid: data["person"]["bioguideid"],
      birthday: SyncHelpers.convert_date(data["person"]["birthday"]),
      cspanid: data["person"]["cspanid"],
      firstname: data["person"]["firstname"],
      gender: data["person"]["gender"],
      gender_label: data["person"]["gender_label"],
      lastname: data["person"]["lastname"],
      link: data["person"]["link"],
      middlename: data["person"]["middlename"],
      name: data["person"]["name"],
      namemod: data["person"]["namemod"],
      nickname: data["person"]["nickname"],
      osid: data["person"]["osid"],
      pvsid: data["person"]["pvsid"],
      sortname: data["person"]["sortname"],
      twitterid: data["person"]["twitterid"],
      youtubeid: data["person"]["youtubeid"],
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

    changeset
      |> SyncHelpers.apply_assoc(:congress_numbers, congress_numbers)
  end
end

defmodule KratosApi.Sync.Bill do
  alias KratosApi.Bill
  alias KratosApi.SyncHelpers

  def sync do
    response = Govtrack.bills([limit: 1])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = Govtrack.bill([id: id])
    save(response["objects"])
  end

  def save(data) do
    params = prepare(data)
    changeset = Bill.changeset(%Bill{}, params) |> add_associations(data)
    SyncHelpers.save(changeset)
  end

  def prepare(data) do
    %{
      govtrack_id: data["id"],
      link: data["link"],
      title_without_number: data["title_without_number"],
      is_current: data["is_current"],
      lock_title: data["lock_title"],
      senate_floor_schedule_postdate: SyncHelpers.convert_date(data["senate_floor_schedule_postdate"]),
      sliplawnum: data["sliplawnum"],
      bill_type: data["bill_type"],
      docs_house_gov_postdate: SyncHelpers.convert_date(data["docs_house_gov_postdate"]),
      noun: data["noun"],
      current_status_date: SyncHelpers.convert_date(data["current_status_date"]),
      source_link: data["source_link"],
      current_status: data["current_status"],
      introduced_date: SyncHelpers.convert_date(data["introduced_date"]),
      bill_type_label: data["bill_type_label"],
      bill_resolution_type: data["bill_resolution_type"],
      display_number: data["display_number"],
      title: data["title"],
      sliplawpubpriv: data["sliplawpubpriv"],
      current_status_label: data["current_status_label"],
      is_alive: data["is_alive"],
      number: data["number"],
      source: data["source"],
      current_status_description: data["current_status_description"],
      titles: data["titles"],
      major_actions: data["major_actions"],
      related_bills: data["related_bills"]
    }
  end

  def add_associations(changeset, data) do
    congress_number = KratosApi.CongressNumber.find_or_create(data["congress"])
    sponsor = KratosApi.Sync.Role.sync(data["sponsor"]["id"])
    committees = if data["committees"], do: Enum.map(data["committees"], &(KratosApi.Committee.find_or_create(&1)))
    terms = if data["terms"], do: Enum.map(data["terms"], &(KratosApi.Term.find_or_create(&1)))
    cosponsors = if data["cosponsors"], do: Enum.map(data["cosponsors"],&(KratosApi.Sync.Role.sync(&1["id"])))

    changeset
      |> SyncHelpers.apply_assoc(:congress_number, congress_number)
      |> SyncHelpers.apply_assoc(:sponsor, sponsor)
      |> SyncHelpers.apply_assoc(:committees, committees)
      |> SyncHelpers.apply_assoc(:cosponsors, cosponsors)
      |> SyncHelpers.apply_assoc(:terms, terms)
  end
end

defmodule KratosApi.Sync.Vote do
  alias KratosApi.Vote
  alias KratosApi.SyncHelpers

  def sync do
    response = Govtrack.votes([limit: 1])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = Govtrack.vote([id: id])
    save(response["objects"])
  end

  def save(data) do
    params = prepare(data)
    changeset = Vote.changeset(%Vote{}, params) |> add_associations(data)
    SyncHelpers.save(changeset)
  end

  def prepare(data) do
    %{
      govtrack_id: data["id"],
      category: data["category"],
      category_label: data["category_label"],
      chamber: data["chamber"],
      chamber_label: data["chamber_label"],
      created: SyncHelpers.convert_datetime(data["created"]),
      link: data["link"],
      margin: data["margin"],
      missing_data: data["missing_data"],
      number: data["number"],
      percent_plus: data["percent_plus"],
      question: data["question"],
      question_details: data["question_details"],
      related_amendment: data["related_amendment"],
      required: data["required"],
      result: data["result"],
      session: data["session"],
      source: data["source"],
      source_label: data["source_label"],
      total_minus: data["total_minus"],
      total_other: data["total_other"],
      total_plus: data["total_plus"],
      vote_type: data["vote_type"],
    }
  end

  def add_associations(changeset, data) do
    congress_number = KratosApi.CongressNumber.find_or_create(data["congress"])
    related_bill = KratosApi.Sync.Bill.sync(data["related_bill"]["id"])

    changeset
      |> SyncHelpers.apply_assoc(:congress_number, congress_number)
      |> SyncHelpers.apply_assoc(:related_bill, related_bill)
  end
end

defmodule KratosApi.Sync.Tally do
  alias KratosApi.Tally
  alias KratosApi.SyncHelpers

  def sync do
    response = Govtrack.vote_voters([limit: 1])
    response["objects"] |> Enum.map(&save/1)
  end

  def sync(id) do
    response = Govtrack.vote_voter([id: id])
    save(response["objects"])
  end

  def save(data) do
    params = prepare(data)
    changeset = Tally.changeset(%Tally{}, params) |> add_associations(data)
    SyncHelpers.save(changeset)
  end

  def prepare(data) do
    %{
      created: SyncHelpers.convert_datetime(data["created"]),
      govtrack_id: data["id"],
      key: data["option"]["key"],
      value: data["option"]["value"],
      voter_type: data["voter_type"],
      voter_type_label: data["voter_type_label"],
      voteview_extra_code: data["voteview_extra_code"],
    }
  end

  def add_associations(changeset, data) do
    person = KratosApi.Role.find_or_create(Map.merge(data["person_role"],%{"person" => data["person"]}))
    vote = KratosApi.Sync.Vote.sync(data["vote"]["id"])

    changeset
      |> SyncHelpers.apply_assoc(:person, person)
      |> SyncHelpers.apply_assoc(:vote, vote)
  end
end
