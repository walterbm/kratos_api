defmodule KratosApi.Sync.Role do
  alias KratosApi.Role

  def sync do
    response = Govtrack.roles([current: true, limit: 10])

    response["objects"] |> Enum.map(&save/1)
  end

  def save(data) do
    params = prepare(data)
    changeset = Role.changeset(%Role{}, params) |> add_associations(data)

    case KratosApi.Repo.insert(changeset) do
      {:ok, role} ->
        role
      {:error, changeset} ->
        changeset.errors
    end

  end

  def prepare (data) do

    {:ok, enddate} =  Date.from_iso8601(data["enddate"])
    {:ok, birthday} =  Date.from_iso8601(data["person"]["birthday"])
    {:ok, startdate} =  Date.from_iso8601(data["startdate"])

    %{
      current: data["current"],
      enddate: enddate,
      description: data["description"],
      govtrack_id: data["person"]["id"],
      caucus: data["caucus"],
      district: data["district"],
      extra: data["extra"],
      leadership_title: data["leadership_title"],
      party: data["party"],
      bioguideid: data["person"]["bioguideid"],
      birthday: birthday,
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
      startdate: startdate,
      state: data["state"],
      title: data["title"],
      title_long: data["title_long"],
      website: data["website"]
    }
  end

  def add_associations(changeset, data) do
    congress_numbers = Enum.map(data["congress_numbers"], &(KratosApi.CongressNumber.find_or_create(&1)))

    changeset |> Ecto.Changeset.put_assoc(:congress_numbers, congress_numbers)
  end

end

defmodule KratosApi.Sync.Bill do
  alias KratosApi.Bill

  require IEx

  def sync do
    response = Govtrack.bills([limit: 1])

    response["objects"] |> Enum.map(&save/1)
  end

  def save(data) do
    params = prepare(data)
    changeset = Bill.changeset(%Bill{}, params) |> add_associations(data)

    case KratosApi.Repo.insert(changeset) do
      {:ok, bill} ->
        bill
      {:error, changeset} ->
        changeset.errors
    end

  end

  def convert_date(date_as_string) do
    unless is_nil(date_as_string) do
      case Date.from_iso8601(date_as_string) do
        {:ok, date} -> date
        {:error, _} -> nil
      end
    end
  end

  def prepare(data) do
    %{
      govtrack_id: data["id"],
      link: data["link"],
      title_without_number: data["title_without_number"],
      is_current: data["is_current"],
      lock_title: data["lock_title"],
      senate_floor_schedule_postdate: convert_date(data["senate_floor_schedule_postdate"]),
      sliplawnum: data["sliplawnum"],
      bill_type: data["bill_type"],
      docs_house_gov_postdate: convert_date(data["docs_house_gov_postdate"]),
      noun: data["noun"],
      current_status_date: convert_date(data["current_status_date"]),
      source_link: data["source_link"],
      current_status: data["current_status"],
      introduced_date: convert_date(data["introduced_date"]),
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
    sponsor = KratosApi.Role.find_or_mark(data["sponsor"]["id"], "bill", data["id"])

    committees = if data["committees"], do: Enum.map(data["committees"], &(KratosApi.Committee.find_or_create(&1)))
    terms = if data["terms"], do: Enum.map(data["terms"], &(KratosApi.Term.find_or_create(&1)))
    cosponsors = if data["cosponsors"], do: Enum.map(data["cosponsors"],&(KratosApi.Role.find_or_mark(&1["id"], "bill", data["id"])))

    changeset
      |> apply_assoc(:congress_number, congress_number)
      |> apply_assoc(:sponsor, sponsor)
      |> apply_assoc(:committees, committees)
      |> apply_assoc(:cosponsors, cosponsors)
      |> apply_assoc(:terms, terms)

  end

  defp apply_assoc(changeset, _, nil), do: changeset
  defp apply_assoc(changeset, field, data), do: Ecto.Changeset.put_assoc(changeset, field, data)

end
