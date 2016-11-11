defmodule KratosApi.Sync.Role do
  alias KratosApi.Role

  def sync do
    response = Govtrack.roles([current: true, limit: 10])

    response.body["objects"] |> Enum.map(&save/1)
  end

  def save(data) do
    params = prepare(data)
    changeset = Role.changeset(%Role{}, params) |> add_association(data)

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

  def add_association(changeset, data) do
    congress_numbers = Enum.map(data["congress_numbers"], &(KratosApi.CongressNumber.find_or_create(&1)))

    changeset |> Ecto.Changeset.put_assoc(:congress_numbers, congress_numbers)
  end

end
