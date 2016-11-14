defmodule KratosApi.Tally do
  use KratosApi.Web, :model

  schema "tallies" do
    field :created, Ecto.DateTime
    field :govtrack_id, :integer
    field :key, :string
    field :value, :string
    field :voter_type, :string
    field :voter_type_label, :string
    field :voteview_extra_code, :string

    belongs_to :person, KratosApi.Role, foreign_key: :role_id
    belongs_to :vote, KratosApi.Vote

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(created key value voter_type voter_type_label voteview_extra_code)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end
end
