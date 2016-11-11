defmodule KratosApi.CongressNumber do
  use KratosApi.Web, :model

  @primary_key {:number, :integer, []}
  schema "congress_numbers" do

    many_to_many :roles, KratosApi.Role, join_through: "role_congress_numbers", join_keys: [congress_number_id: :number, role_id: :id]

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

  def find_or_create(number) do
    congress_number = KratosApi.CongressNumber |> KratosApi.Repo.get(number)
    if !congress_number do
      congress_number = %KratosApi.CongressNumber{number: number}
      KratosApi.Repo.insert(congress_number)
    else
      congress_number
    end
  end
end
