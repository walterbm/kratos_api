defmodule KratosApi.RoleCongressNumber do
  use KratosApi.Web, :model

  schema "role_congress_numbers" do
    belongs_to :role, KratosApi.Role
    belongs_to :congress_number, KratosApi.CongressNumber

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
