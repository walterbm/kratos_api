defmodule KratosApi.Sync.Person do

  alias KratosApi.{
    Repo,
    SyncHelpers,
    Person,
    Fec,
    Term
  }

  @term_types %{"sen" => "Senate", "rep" => "House"}
  @files %{
    current: "legislators-current.yaml",
    historical: "legislators-historical.yaml",
    executive: "executive.yaml"
  }

  def sync(type \\ :current) do
    SyncHelpers.sync_from_storage(@files[type], &save/1)
  end

  defp save(data) do
    params = prepare(data)
    changeset = Person.changeset(%Person{}, params) |> add_associations(data)
    SyncHelpers.save(changeset, [bioguide: data['id']['bioguide'] |> to_string ])
  end

  defp prepare(data) do
    last_term =
      Map.get(data, 'terms', [%{}])
      |> Enum.sort(&(&1['end'] >= &2['end']))
      |> List.first

    current? = Date.compare(SyncHelpers.convert_date(last_term['end']), Date.utc_today())
    is_current?(data, current?, last_term)
  end

  defp is_current?(data, :lt, _) do
    Map.merge(prepare_common(data), %{
      is_current: false,
      current_office: nil,
      current_state: nil,
      current_district: nil,
      current_party: nil,
    })
  end

  defp is_current?(data, :gt, current_term) do
    Map.merge(prepare_common(data), %{
      is_current: true,
      current_office: @term_types[current_term['type'] |> to_string],
      current_state: current_term['state'] |> to_string,
      current_district: current_term['district'] |> to_string,
      current_party: current_term['party']|> to_string,
    })
  end

  defp prepare_common(data) do
    %{
      bioguide: data['id'] |> bioguide?,
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

  defp bioguide?(id_data) do
    if id_data['bioguide'] do
      id_data['bioguide'] |> to_string
    else
      id_data['wikipedia'] |> to_string
    end
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

  def sync do
    SyncHelpers.sync_from_storage("legislators-social-media.yaml", &save/1)
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

defmodule KratosApi.Sync.Person.Bio do
  alias KratosApi.{
    Repo,
    Person
  }
  import Ecto.Query

  @remote_service Application.get_env(:kratos_api, :remote_service)

  def sync do
    current_reps()
    |> Flow.from_enumerable()
    |> Flow.map(&fetch_bio/1)
    |> Flow.map(&save_bio/1)
    |> Flow.reject(&(elem(&1,0) == :ok))
    |> Enum.to_list()
    |> verifty()
  end

  defp current_reps do
    Repo.all(
      from p in Person,
      where: p.is_current == true,
      select: %{
        id: p.id,
        wikipedia: p.wikipedia
      })
  end

  defp fetch_bio(%{id: id, wikipedia: wikipedia}) do
    %{
      id: id,
      bio: @remote_service.fetch_bio(wikipedia)
    }
  end

  defp save_bio(%{id: id, bio: bio}) do
    person = Repo.get!(Person, id) |> Ecto.Changeset.change(bio: bio)
    Repo.update(person)
  end

  defp verifty([]), do: {:ok, "success"}
  defp verifty(failed_records) do
    raise BioSyncError, message: "Bio sync failed for People with id(s): #{Enum.map(failed_records, &(elem(&1,1).id))}"
  end

end
