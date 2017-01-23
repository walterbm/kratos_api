defmodule KratosApi.Sync.Person do

  alias KratosApi.{
    Repo,
    SyncHelpers,
    Person,
    Fec,
    Term
  }

  @remote_storage Application.get_env(:kratos_api, :remote_storage)
  @term_types %{"sen" => "Senate", "rep" => "House"}
  @files %{current: "legislators-current.yaml", historical: "legislators-historical.yaml"}

  def sync(type \\ :current) do
    {document, hash} = @remote_storage.fetch_file(@files[type])
    document
      |> @remote_storage.parse_file
      |> Enum.map(&SyncHelpers.convert_to_map/1)
      |> Enum.map(&(save(&1, type)))
  end

  defp save(data, type) do
    params = prepare(data, type)
    changeset = Person.changeset(%Person{}, params) |> add_associations(data)
    SyncHelpers.save(changeset, [bioguide: data['id']['bioguide'] |> to_string ])
  end

  defp prepare(data, :current) do

    current_term =
      Map.get(data, 'terms', [%{}])
      |> Enum.sort(&(&1['end'] >= &2['end']))
      |> List.first

    Map.merge(prepare_common(data), %{
      is_current: true,
      current_office: @term_types[current_term['type'] |> to_string],
      current_state: current_term['state'] |> to_string,
      current_district: current_term['district'] |> to_string,
      current_party: current_term['party']|> to_string,
    })
  end

  defp prepare(data, :historical) do
    Map.merge(prepare_common(data), %{
      is_current: false,
      current_office: nil,
      current_state: nil,
      current_district: nil,
      current_party: nil,
    })
  end

  defp prepare_common(data) do
    %{
      bioguide: data['id']['bioguide'] |> to_string,
      thomas: data['id']['thomas'] |> to_string,
      lis: data['id']['lis'] |> to_string,
      opensecrets: data['id']['opensecrets'] |> to_string,
      votesmart: data['id']['votesmart'] |> to_string,
      cspan: data['id']['cspan'] |> to_string,
      wikipedia: data['id']['wikipedia'] |> to_string,
      house_history: data['id']['house_history'] |> to_string,
      ballotpedia: data['id']['ballotpedia'] |> to_string,
      maplight: data['id']['maplight'] |> to_string,
      icpsr: data['id']['icpsr'] |> to_string,
      wikidata: data['id']['wikidata'] |> to_string,
      google_entity_id: data['id']['google_entity_id'] |> to_string,
      first_name: data['name']['first'] |> to_string,
      last_name: data['name']['last'] |> to_string,
      official_full_name: data['name']['official_full'] |> to_string,
      birthday: SyncHelpers.convert_date(data['bio']['birthday']),
      gender: data['bio']['gender'] |> to_string,
      religion: data['bio']['religion'] |> to_string,
      image_url: "#{Application.get_env(:kratos_api, :assets_url)}/225x275/#{data['id']['bioguide'] |> to_string}.jpg"
    }
  end

  defp add_associations(changeset, data) do
    fec = Enum.map(Map.get(data['id'],'fec', []), &(Fec.create(&1 |> to_string))) |> Enum.reject(&is_nil/1)
    terms = Enum.map(Map.get(data, 'terms', []), fn(term) ->
      term |> KratosApi.Sync.Term.prepare |> Term.create
    end) |> Enum.reject(&is_nil/1)

    changeset
      |> SyncHelpers.apply_assoc(:fec, fec)
      |> SyncHelpers.apply_assoc(:terms, terms)
  end
end

defmodule KratosApi.Sync.Person.SocialMedia do
  alias KratosApi.{
    Repo,
    Person,
    SyncHelpers
  }

  @remote_storage Application.get_env(:kratos_api, :remote_storage)

  def sync do
    {document, hash} = @remote_storage.fetch_file("legislators-social-media.yaml")
    document
      |> @remote_storage.parse_file
      |> Enum.map(&SyncHelpers.convert_to_map/1)
      |> Enum.map(&save/1)
  end

  defp save(data) do
    params = prepare(data)
    Repo.get_by!(Person, bioguide: data['id']['bioguide'] |> to_string)
      |> Ecto.Changeset.change(params)
      |> Repo.update!
  end

  defp prepare(data) do
    %{
      facebook: data['social']['facebook'] |> to_string,
      facebook_id: data['social']['facebook_id'] |> to_string,
      twitter: data['social']['twitter'] |> to_string,
      youtube: data['social']['youtube'] |> to_string,
      youtube_id: data['social']['youtube_id'] |> to_string,
      twitter_id: data['social']['twitter_id'] |> to_string,
      instagram: data['id']['instagram'] |> to_string,
      instagram_id: data['id']['instagram_id'] |> to_string,
    }
  end
end
