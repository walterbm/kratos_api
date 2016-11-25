defmodule KratosApi.PersonRoles do
  use KratosApi.Web, :model

  schema "person_roles" do
    belongs_to :person, KratosApi.Person
    belongs_to :role, KratosApi.Role

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
