defmodule KratosApi.Sync.Committee do
  alias KratosApi.{
    Committee,
    SyncHelpers
  }

  @remote_storage Application.get_env(:kratos_api, :remote_storage)

  def sync do
    {document, hash} = @remote_storage.fetch_file("committees-current.yaml")
    document
      |> @remote_storage.parse_file
      |> Enum.map(&SyncHelpers.convert_to_map/1)
      |> Enum.map(&save/1)
  end

  defp save(data) do
    params = prepare(data)
    changeset = Committee.changeset(%Committee{}, params)
    SyncHelpers.save(changeset, [thomas_id: data['thomas_id'] |> to_string ])
  end

  defp prepare (data) do
    %{
      type: data['type'] |> to_string,
      name: data['name'] |> to_string,
      thomas_id: data['thomas_id'] |> to_string,
      senate_committee_id: data['senate_committee_id'] |> to_string,
      house_committee_id: data['house_committee_id'] |> to_string,
      jurisdiction: data['jurisdiction'] |> to_string,
      jurisdiction_source: data['jurisdiction_source'] |> to_string,
      url: data['url'] |> to_string,
      address: data['address'] |> to_string,
      phone: data['phone'] |> to_string,
      rss_url: data['rss_url'] |> to_string,
      minority_rss_url: data['minority_rss_url'] |> to_string,
      minority_url: data['minority_url'] |> to_string,
      past_names: data['past_names'] |> to_string,
    }
  end
end

defmodule KratosApi.Sync.Committee.Membership do
  import Ecto.Query

  alias KratosApi.{
    Repo,
    Person,
    Committee,
    CommitteeMember,
    SyncHelpers,
  }

  @remote_storage Application.get_env(:kratos_api, :remote_storage)

  def sync do
    {document, hash} = @remote_storage.fetch_file("committee-membership-current.yaml")
    document
      |> @remote_storage.parse_file
      |> Enum.map(&SyncHelpers.convert_to_map/1)
      |> Enum.map(&save/1)
  end

  defp save(data) do
    thomas_id = Map.keys(data) |> List.first |> to_string
    Repo.one(from c in Committee, where: c.thomas_id == ^thomas_id, preload: [:members])
      |> build_members(data)
  end

  defp build_members(nil, _data), do: false
  defp build_members(committee, data) do
    unless committee.members |> Enum.empty?, do: delete_all_members(committee.id)
    changeset = Committee.changeset(committee) |> add_associations(data)
    SyncHelpers.save(changeset, [thomas_id: committee.thomas_id])
  end

  defp delete_all_members(committee_id) do
     from(member in CommitteeMember,
     where: member.committee_id == ^committee_id)
     |> Repo.delete_all
  end

  defp add_associations(changeset, data) do
    [ members ] = Map.values(data)
    members = Enum.map(members, fn(member) ->
      person = Repo.get_by(Person, bioguide: member['bioguide'] |> to_string)
      CommitteeMember.create(person, changeset.data, member['title'] |> to_string)
    end) |> Enum.reject(&(is_nil(&1)))

    changeset
      |> SyncHelpers.apply_assoc(:members, members)
  end
end
