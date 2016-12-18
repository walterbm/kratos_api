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

  def create(data, key) do
    person_id = case Repo.get_by(Person, bioguideid: data["id"]) do
      nil ->
        case Repo.get_by(Person, lastname: Map.get(data, "last_name", "")) do
          nil -> nil
          person -> person.id
        end
      person -> person.id
    end
    if person_id, do: Repo.insert!(%Vote{value: key, person_id: person_id})
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

# "votes": {
#     "Nay": [
#       {
#         "display_name": "Baldwin (D-WI)",
#         "first_name": "Tammy",
#         "id": "S354",
#         "last_name": "Baldwin",
#         "party": "D",
#         "state": "WI"
#       }
#     ],
#     "Not Voting": [
#       {
#         "display_name": "Kaine (D-VA)",
#         "first_name": "Timothy",
#         "id": "S362",
#         "last_name": "Kaine",
#         "party": "D",
#         "state": "VA"
#       }
#     ],
#     "Present": [],
#     "Yea": [
#       {
#         "display_name": "Alexander (R-TN)",
#         "first_name": "Lamar",
#         "id": "S289",
#         "last_name": "Alexander",
#         "party": "R",
#         "state": "TN"
#       }
#     ]
#   }
