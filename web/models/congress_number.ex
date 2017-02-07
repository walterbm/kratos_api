defmodule KratosApi.CongressNumber do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    CongressNumber
  }

  @primary_key {:number, :integer, []}
  schema "congress_numbers" do
    timestamps()
  end

  def primary_key, do: elem(@primary_key, 0)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:number])
    |> validate_required([:number])
  end

  def find_or_create(number) when is_binary(number) do
    {number, _} = Integer.parse(number)
    find_or_create(number)
  end
  def find_or_create(number) do
    case Repo.get(CongressNumber, number) do
      nil ->
        {:ok, congress_number} = KratosApi.Repo.insert(%KratosApi.CongressNumber{number: number})
        congress_number
      congress_number -> congress_number
    end
  end

end
