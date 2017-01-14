defmodule KratosApi.Fec do
  use KratosApi.Web, :model

  schema "fec" do
    field :number, :string
    belongs_to :person, KratosApi.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number])
    |> validate_required([:number])
  end
end
