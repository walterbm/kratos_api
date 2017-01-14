defmodule KratosApi.CommitteeMember do
  use KratosApi.Web, :model

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
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
