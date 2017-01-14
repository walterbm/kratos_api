defmodule KratosApi.CommitteeCongressNumbers do
  use KratosApi.Web, :model

  schema "committee_congress_numbers" do
    belongs_to :committee, KratosApi.Committee
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
