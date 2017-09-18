defmodule KratosApi.TrendingBill do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    TrendingBill
  }

  schema "trending_bills" do
    field :source, :string
    field :md5, :string
    belongs_to :bill, KratosApi.Bill

    timestamps()
  end

  @required_fields ~w(source md5)a
  @allowed_fields ~w(bill_id source md5)a

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def delete_all(source) do
    query =
      from td in TrendingBill,
      where: td.source == ^source

    Repo.delete_all(query)
  end
end
