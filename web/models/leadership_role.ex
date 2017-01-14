defmodule KratosApi.LeadershipRole do
  use KratosApi.Web, :model

  schema "leadership_roles" do
    field :title, :string
    field :chamber, :string
    field :start, Ecto.Date
    field :end, Ecto.Date
    belongs_to :person, KratosApi.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :chamber, :start, :end])
    |> validate_required([])
  end
end
