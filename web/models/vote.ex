defmodule KratosApi.Vote do
  use KratosApi.Web, :model

  alias KratosApi.{
    Vote,
    Person,
    Repo
  }

  schema "votes" do
    field :value, :string
    belongs_to :tally, KratosApi.Tally
    belongs_to :person, KratosApi.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value, :person_id, :tally_id])
    |> validate_required([:value])
  end

  # Handle special case for Mike Pence
  def create("VP", key) do
    case Repo.get_by(Person, bioguide: "P000587") do
      nil -> nil
      person -> Repo.insert!(%Vote{value: key, person_id: person.id})
    end
  end
  # Senate votes
  def create(%{"display_name" => _, "first_name" => _, "id" => id, "last_name" => _, "party" => _, "state" => _}, key) do
    case Repo.one(from p in Person, where: [lis: ^id]) do
      nil -> nil
      person -> Repo.insert!(%Vote{value: key, person_id: person.id})
    end
  end
  # House votes
  def create(%{"display_name" => _, "id" => id, "party" => _, "state" => _}, key) do
    case Repo.get_by(Person, bioguide: id) do
      nil -> nil
      person -> Repo.insert!(%Vote{value: key, person_id: person.id})
    end
  end

  def mass_create(vote_data_map) do
    Map.keys(vote_data_map)
    |> Enum.map(fn vote_key ->
      Enum.map(vote_data_map[vote_key],&(Vote.create(&1, vote_key)))
    end)
    |> List.flatten
    |> Enum.reject(&(is_nil(&1)))
  end

end
