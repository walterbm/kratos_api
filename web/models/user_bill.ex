defmodule KratosApi.UserBill do
  use KratosApi.Web, :model

  schema "user_bills" do
    belongs_to :user, KratosApi.User
    belongs_to :bill, KratosApi.Bill

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
