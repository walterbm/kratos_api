defmodule KratosApi.FloorActivity do
  use KratosApi.Web, :model

  schema "flooractivities" do
    field :chamber, :string
    field :title, :string
    field :description, :string
    field :link, :string
    field :published_at, Ecto.DateTime
    field :md5, :string
    belongs_to :bill, KratosApi.Bill

    timestamps()
  end

  @required_fields ~w(chamber title published_at md5)a
  @allowed_fields ~w(chamber title description link published_at md5)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end
end
