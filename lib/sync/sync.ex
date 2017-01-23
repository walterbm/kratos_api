# @TODO
# ** (DBConnection.ConnectionError) tcp recv: connection timed out - :etimedout
#     (ecto) lib/ecto/adapters/postgres/connection.ex:99: Ecto.Adapters.Postgres.Connection.execute/4
#     (ecto) lib/ecto/adapters/sql.ex:243: Ecto.Adapters.SQL.sql_call/6
#     (ecto) lib/ecto/adapters/sql.ex:193: Ecto.Adapters.SQL.query!/5
#     (ecto) lib/ecto/adapters/postgres.ex:86: Ecto.Adapters.Postgres.insert_all/7
#     (ecto) lib/ecto/repo/schema.ex:52: Ecto.Repo.Schema.do_insert_all/7
#     (ecto) lib/ecto/association.ex:963: Ecto.Association.ManyToMany.on_repo_change/4
#     (ecto) lib/ecto/association.ex:330: anonymous fn/7 in Ecto.Association.on_repo_change/6
#     (elixir) lib/enum.ex:1755: Enum."-reduce/3-lists^foldl/2-0-"/3
#     (ecto) lib/ecto/association.ex:327: Ecto.Association.on_repo_change/6
#     (elixir) lib/enum.ex:1755: Enum."-reduce/3-lists^foldl/2-0-"/3
#     (ecto) lib/ecto/association.ex:293: Ecto.Association.on_repo_change/3
#     (ecto) lib/ecto/repo/schema.ex:609: Ecto.Repo.Schema.process_children/4
#     (ecto) lib/ecto/repo/schema.ex:676: anonymous fn/3 in Ecto.Repo.Schema.wrap_in_transaction/6
#     (ecto) lib/ecto/adapters/sql.ex:615: anonymous fn/3 in Ecto.Adapters.SQL.do_transaction/3
#     (db_connection) lib/db_connection.ex:1274: DBConnection.transaction_run/4
#     (db_connection) lib/db_connection.ex:1198: DBConnection.run_begin/3
#     (db_connection) lib/db_connection.ex:789: DBConnection.transaction/3
#     (kratos_api) lib/sync/sync.ex:52: KratosApi.SyncHelpers.save/2
#     (elixir) lib/enum.ex:1229: Enum."-map/2-lists^map/1-0-"/2
#     (elixir) lib/enum.ex:1229: Enum."-map/2-lists^map/1-0-"/2



defmodule KratosApi.SyncHelpers do

  def apply_assoc(changeset, _, nil), do: changeset
  def apply_assoc(changeset, field, data), do: Ecto.Changeset.put_assoc(changeset, field, data)

  def convert_date(date_as_string), do: convert_date_or_datetime(date_as_string, Date)

  def convert_datetime(date_as_string), do: convert_date_or_datetime(date_as_string, NaiveDateTime)

  defp convert_date_or_datetime(date, date_module) when is_list(date) do
    convert_date_or_datetime(to_string(date), date_module)
  end
  defp convert_date_or_datetime(date_as_string, date_module) do
    unless is_nil(date_as_string) do
      case date_module.from_iso8601(date_as_string) do
        {:ok, date} -> date
        {:error, _} -> nil
      end
    end
  end

  def convert_to_map([head | tail]) when is_list(head) do
    Enum.map([head | tail], &(convert_to_map(&1)))
  end
  def convert_to_map([head | tail]) when is_tuple(head) do
    Enum.into([head | tail], %{}) |> convert_to_map
  end
  def convert_to_map(x) when is_map(x) do
    Enum.reduce(x, %{}, fn({k, v}, acc) ->
      Map.merge(acc, %{k => convert_to_map(v)})
    end)
  end
  def convert_to_map({key, value}) do
    %{key => value} |> convert_to_map
  end
  def convert_to_map(x), do: x

  def flat_map_to_string(data) when is_list(data) do
    Enum.map(data, &flat_map_to_string/1)
  end
  def flat_map_to_string(data) when is_map(data) do
    Enum.reduce(data, %{}, fn({k, v}, acc) ->
      Map.merge(acc, %{to_string(k) => to_string(v)})
    end)
  end
  def flat_map_to_string(nil), do: nil

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
      {:error, changeset} -> changeset.errors
    end
  end
end


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

defmodule  KratosApi.Sync.Term do

  alias KratosApi.{
    SyncHelpers
  }

  @term_types %{"sen" => "Senate", "rep" => "House"}

  def prepare(data) do
    %{
      type: @term_types[data['type'] |> to_string],
      start: SyncHelpers.convert_date(data['start']),
      end: SyncHelpers.convert_date(data['end']),
      state: data['state'] |> to_string,
      district: data['district'] |> to_string,
      class: data['class'] |> to_string,
      state_rank: data['state_rank'] |> to_string,
      party: data['party'] |> to_string,
      caucus: data['caucus'] |> to_string,
      party_affiliations: data['party_affiliations'] |> SyncHelpers.flat_map_to_string,
      url: data['url'] |> to_string,
      address: data['address'] |> to_string,
      phone: data['phone'] |> to_string,
      fax: data['fax'] |> to_string,
      contact_form: data['contact_form'] |> to_string,
      office: data['office'] |> to_string,
      rss_url: data['rss_url'] |> to_string,
    }
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
      KratosApi.CommitteeMember.create(person, changeset.data, member['title'] |> to_string)
    end) |> Enum.reject(&(is_nil(&1)))

    changeset
      |> SyncHelpers.apply_assoc(:members, members)
  end
end

defmodule KratosApi.Sync.Bill do

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

  @remote_queue Application.get_env(:kratos_api, :remote_queue)

  def sync do
    @remote_queue.fetch_queue("congress-bills") |> Enum.map(&save/1)
  end

  defp save(raw_message) do
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

  defp prepare(data, raw_message) do
    %{
      actions: Enum.sort(data["actions"], &(&1["acted_at"] >= &2["acted_at"])),
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
      status_at: SyncHelpers.convert_datetime(data["status_at"]),
      top_term: data["subjects_top_term"],
      summary_text: data["summary"]["text"],
      summary_date: SyncHelpers.convert_datetime(data["summary"]["date"]),
      titles: data["titles"],
      gpo_data_updated_at: SyncHelpers.convert_datetime(data["updated_at"]),
      source_url: data["url"],
      md5_of_body: raw_message.md5_of_body
    }
  end

  defp add_associations(changeset, data) do
    congress_number = CongressNumber.find_or_create(elem(Integer.parse(data["congress"]),0))
    sponsor = Repo.get_by(Person, bioguide: data["sponsor"]["bioguide_id"])
    committees =
      Enum.map(data["committees"], &(Repo.get_by(Committee, thomas_id: &1["committee_id"])))
      |> Enum.reject(&(is_nil(&1)))
    subjects = Enum.map(data["subjects"], &(Subject.find_or_create(&1)))
    cosponsors =
      Enum.map(data["cosponsors"],&(Repo.get_by(Person, bioguide: &1["bioguide_id"])))
      |> Enum.reject(&(is_nil(&1)))
    related_bills =
      Enum.map(data["related_bills"], &(RelatedBill.create(&1)))
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
      gpo_id: data["vote_id"],
      md5_of_body: raw_message.md5_of_body
    }
  end

  defp add_associations(changeset, data) do
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
