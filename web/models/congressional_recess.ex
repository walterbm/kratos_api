defmodule KratosApi.CongressionalRecess do
  use KratosApi.Web, :model

  schema "congressional_recess" do
    field :start_date, Ecto.Date
    field :end_date, Ecto.Date
    field :year, :integer
    field :chamber, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:year, :start, :end, :chamber])
    |> validate_required([:year, :start, :end, :chamber])
  end
end
