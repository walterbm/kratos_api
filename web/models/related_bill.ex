defmodule KratosApi.RelatedBill do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Bill,
    RelatedBill
  }

  schema "related_bills" do
    field :reason, :string

    belongs_to :bill, KratosApi.Bill
    belongs_to :related_bill, KratosApi.Bill
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  def create(related_bill_data) do
    case Repo.get_by(Bill, gpo_id: related_bill_data["bill_id"]) do
      nil -> nil
      bill ->
        {:ok, related_bill} = Repo.insert(%RelatedBill{related_bill: bill, reason: related_bill_data["reason"]})
        related_bill
    end
  end
end
