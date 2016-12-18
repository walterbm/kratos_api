defmodule KratosApi.Committee do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Committee
  }

  schema "committees" do
    field :code, :string
    field :abbrev, :string
    field :name, :string
    field :govtrack_id, :integer
    field :committee_type, :string
    field :committee_type_label, :string
    field :jurisdiction, :string
    field :jurisdiction_link, :string
    field :obsolete, :boolean, default: false
    field :url, :string

    belongs_to :parent, KratosApi.Committee, foreign_key: :parent_id
    has_many :sub_committees, KratosApi.Committee, foreign_key: :parent_id

    timestamps()
  end

  @required_fields ~w(code govtrack_id)
  @optional_fields ~w(abbrev name committee_type committee_type_label jurisdiction jurisdiction_link obsolete url)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_create(data) do
    case Repo.get_by(Committee, govtrack_id: data["id"]) do
      nil -> KratosApi.Sync.Committee.save(data)
      committee -> committee
    end
  end

end
