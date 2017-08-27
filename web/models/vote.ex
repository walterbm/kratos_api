defmodule KratosApi.Vote do
  use KratosApi.Web, :model

  alias KratosApi.{
    Vote,
    Term,
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

  def create(params, key) do
    create_changeset(params, key) |> Repo.insert!
  end

  # Handle special case for Vice Presidents
  def create_changeset("VP", key) do
    case Repo.one(from t in Term, where: t.type == "VP", where: t.end > ^Date.utc_today()) do
      nil -> nil
      term -> Vote.changeset(%Vote{}, %{value: key, person_id: term.person_id})
    end
  end
  # Senate votes
  def create_changeset(%{"display_name" => _, "first_name" => _, "id" => id, "last_name" => _, "party" => _, "state" => _}, key) do
    case Repo.one(from p in Person, where: [lis: ^id]) do
      nil -> nil
      person -> Vote.changeset(%Vote{}, %{value: key, person_id: person.id})
    end
  end
  # House votes
  def create_changeset(%{"display_name" => _, "id" => id, "party" => _, "state" => _}, key) do
    case Repo.get_by(Person, bioguide: id) do
      nil -> nil
      person -> Vote.changeset(%Vote{}, %{value: key, person_id: person.id})
    end
  end

  def mass_create_changeset(vote_data_map) do
    vote_data_map
    |> Map.keys
    |> Enum.map(fn vote_key ->
      Enum.map(vote_data_map[vote_key],&(create_changeset(&1, vote_key)))
    end)
    |> List.flatten
    |> Enum.reject(&is_nil/1)
  end

end
