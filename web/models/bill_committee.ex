defmodule KratosApi.BillCommittee do
  use KratosApi.Web, :model

  schema "bill_committees" do
    belongs_to :bill, KratosApi.Bill
    belongs_to :committee, KratosApi.Committee

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
