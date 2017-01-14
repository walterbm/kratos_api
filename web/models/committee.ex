defmodule KratosApi.Committee do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Committee
  }

  schema "committees" do
    field :type, :string
    field :name, :string
    field :thomas_id, :string
    field :senate_committee_id, :string
    field :house_committee_id, :string
    field :jurisdiction, :string
    field :jurisdiction_source, :string
    field :url, :string
    field :address, :string
    field :phone, :string
    field :rss_url, :string
    field :minority_rss_url, :string
    field :past_names, :map

    belongs_to :parent_committee, KratosApi.Committee, foreign_key: :parent_id

    has_many :sub_committees, KratosApi.Committee, foreign_key: :parent_id
    has_many :members, KratosApi.CommitteeMember

    many_to_many :congress_numbers, KratosApi.CongressNumber, join_through: "committee_congress_numbers", join_keys: [committee_id: :id, congress_number_id: :number]

    timestamps()
  end


  @required_fields []
  @allowed_fields ~w(type name thomas_id senate_committee_id house_committee_id jurisdiction jurisdiction_source url
    address phone rss_url minority_rss_url past_names parent_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def find_or_create(data) do
    case Repo.get_by(Committee, govtrack_id: data["id"]) do
      nil -> KratosApi.Sync.Committee.save(data)
      committee -> committee
    end
  end

end
