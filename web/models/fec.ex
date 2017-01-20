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
    |> cast(params, [:number, :person_id])
    |> validate_required([:number])
  end

  def create(number) do
    case KratosApi.Repo.insert(%KratosApi.Fec{number: number}) do
      {:ok, fec} -> fec
    end
  end

end
