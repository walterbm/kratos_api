defmodule KratosApi.BillCosponsor do
  use KratosApi.Web, :model

  schema "bill_cosponsors" do
    belongs_to :bill, KratosApi.Bill
    belongs_to :cosponsor, KratosApi.Role, foreign_key: :role_id
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
