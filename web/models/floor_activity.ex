defmodule KratosApi.FloorActivity do
  use KratosApi.Web, :model

  schema "flooractivities" do
    field :chamber, :string
    field :title, :string
    field :description, :string
    field :link, :string
    field :day, Ecto.Date
    belongs_to :bill, KratosApi.Bill

    timestamps()
  end

  @required_fields ~w(chamber title day)a
  @allowed_fields ~w(chamber title description link day)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end
end
