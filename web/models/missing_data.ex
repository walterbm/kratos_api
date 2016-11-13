defmodule KratosApi.MissingData do
  use KratosApi.Web, :model

  schema "missing_data" do
    field :type, :string
    field :govtrack_id, :integer
    field :caller, :string
    field :caller_id, :integer
    field :collected, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :govtrack_id, :collected])
    |> validate_required([:type, :govtrack_id])
  end
end
