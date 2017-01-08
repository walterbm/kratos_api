defmodule KratosApi.UserAction do
  use KratosApi.Web, :model

  schema "user_actions" do
    field :action, :string
    field :last_bill_seen_at, Ecto.DateTime
    field :last_tally_seen_at, Ecto.DateTime
    belongs_to :user, KratosApi.User
    belongs_to :last_bill, KratosApi.Bill
    belongs_to :last_tally, KratosApi.Tally

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    params = Map.merge(params, %{
      "last_bill_seen_at" => KratosApi.Convert.Date.convert_datetime(params["last_bill_seen_at"]),
      "last_tally_seen_at" => KratosApi.Convert.Date.convert_datetime(params["last_tally_seen_at"]),
    })

    struct
    |> cast(params, [:action, :last_bill_seen_at, :last_tally_seen_at, :user_id, :last_bill_id, :last_tally_id])
    |> validate_required([:action, :user_id])
    |> foreign_key_constraint(:last_bill_id)
    |> foreign_key_constraint(:last_tally_id)
  end
end
