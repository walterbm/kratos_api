defmodule KratosApi.Person do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Person
  }

  schema "persons" do
    field :govtrack_id, :integer
    field :cspanid, :integer
    field :bioguideid, :string
    field :birthday, Ecto.Date
    field :firstname, :string
    field :gender, :string
    field :gender_label, :string
    field :lastname, :string
    field :link, :string
    field :middlename, :string
    field :name, :string
    field :current_party, :string
    field :current_state, :string
    field :namemod, :string
    field :nickname, :string
    field :osid, :string
    field :pvsid, :string
    field :sortname, :string
    field :twitterid, :string
    field :youtubeid, :string
    field :image_url, :string

    has_many :roles, KratosApi.Role
    has_many :votes, KratosApi.Vote

    many_to_many :committee_assignments, KratosApi.Committee, join_through: "person_committees", join_keys: [person_id: :id, committeeassignment_id: :committee_id]

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(cspanid bioguideid birthday firstname gender gender_label lastname link middlename
    name current_party current_state namemod nickname osid pvsid sortname twitterid
    youtubeid image_url)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(data) do
    case Repo.get_by(Person, govtrack_id: data["id"]) do
      nil -> KratosApi.Sync.Person.save(data)
      person -> person
    end
  end
end
