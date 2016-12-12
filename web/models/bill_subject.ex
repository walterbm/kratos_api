defmodule KratosApi.BillSubject do
  use KratosApi.Web, :model

  schema "bill_subjects" do
    belongs_to :bill, KratosApi.Bill
    belongs_to :subjects, KratosApi.Subject
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
