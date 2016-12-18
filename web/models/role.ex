defmodule KratosApi.Role do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Role
  }

  schema "roles" do

    field :current, :boolean, default: false
    field :enddate, Ecto.Date
    field :description, :string
    field :govtrack_id, :integer
    field :caucus, :string
    field :district, :integer
    field :extra, :map
    field :leadership_title, :string
    field :party, :string
    field :phone, :string
    field :role_type, :string
    field :role_type_label, :string
    field :senator_class, :string
    field :senator_class_label, :string
    field :senator_rank, :string
    field :senator_rank_label, :string
    field :startdate, Ecto.Date
    field :state, :string
    field :title, :string
    field :title_long, :string
    field :website, :string

    belongs_to :person, KratosApi.Person

    many_to_many :congress_numbers, KratosApi.CongressNumber, join_through: "role_congress_numbers", join_keys: [role_id: :id, congress_number_id: :number]

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(current enddate description caucus district extra leadership_title party phone role_type
    role_type_label senator_class senator_class_label senator_rank senator_rank_label startdate state title
    title_long website)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(data) do
    case Repo.get_by(Role, govtrack_id: data["id"]) do
      nil -> KratosApi.Sync.Role.save(data)
      role -> role
    end
  end

end
