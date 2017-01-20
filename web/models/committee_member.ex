defmodule KratosApi.CommitteeMember do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    CommitteeMember
  }

  schema "committee_members" do
    field :title, :string
    belongs_to :committee, KratosApi.Committee
    belongs_to :person, KratosApi.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :person_id, :committee_id])
    |> validate_required([:person_id, :committee_id])
  end

  def create(nil, _committee, _title), do: nil
  def create(person, committee, title) do
    Repo.insert!(%CommitteeMember{person_id: person.id, committee_id: committee.id, title: title})
  end
end
