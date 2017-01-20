defmodule KratosApi.Person do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Person
  }

  schema "persons" do
    field :bioguide, :string
    field :thomas, :string
    field :lis, :string
    field :opensecrets, :string
    field :votesmart, :string
    field :cspan, :string
    field :wikipedia, :string
    field :house_history, :string
    field :ballotpedia, :string
    field :maplight, :string
    field :icpsr, :string
    field :wikidata, :string
    field :google_entity_id, :string
    field :first_name, :string
    field :last_name, :string
    field :official_full_name, :string
    field :birthday, Ecto.Date
    field :gender, :string
    field :religion, :string
    field :twitter, :string
    field :twitter_id, :string
    field :facebook, :string
    field :facebook_id, :string
    field :youtube, :string
    field :youtube_id, :string
    field :instagram, :string
    field :instagram_id, :string
    field :image_url, :string
    field :bio, :string
    field :is_current, :boolean
    field :current_office, :string
    field :current_state, :string
    field :current_district, :integer

    has_many :fec, KratosApi.Fec
    has_many :committee_memberships, KratosApi.CommitteeMember
    has_many :terms, KratosApi.Term
    has_many :leadership_roles, KratosApi.LeadershipRole
    has_many :votes, KratosApi.Vote

    many_to_many :committee_assignments, KratosApi.Committee, join_through: "person_committees", join_keys: [person_id: :id, committeeassignment_id: :committee_id]

    timestamps()
  end

  @required_fields ~w(bioguide)a
  @allowed_fields ~w(bioguide thomas lis opensecrets votesmart cspan wikipedia house_history ballotpedia maplight icpsr wikidata
    google_entity_id first_name last_name official_full_name birthday gender religion twitter facebook youtube instagram facebook_id youtube_id
    twitter_id instagram_id image_url is_current current_office current_state current_district)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def find_or_create(data) do
    case Repo.get_by(Person, govtrack_id: data["id"]) do
      nil -> KratosApi.Sync.Person.save(data)
      person -> person
    end
  end
end
