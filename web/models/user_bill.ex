defmodule KratosApi.UserBill do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Bill,
    UserBill
  }

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
    |> cast(params, [:user_id, :subject_id])
    |> validate_required([:user_id, :subject_id])
  end

  def get_or_create(user_id, bill_id) when is_binary(bill_id), do: get_or_create(user_id, String.to_integer(bill_id))
  def get_or_create(user_id, bill_id) do
    case __MODULE__ |> KratosApi.Repo.get_by([user_id: user_id, bill_id: bill_id]) do
      nil -> KratosApi.Repo.insert!(%__MODULE__{bill_id: bill_id, user_id: user_id})
      user_bill -> user_bill
    end
  end

  def following_query(user_id) do
    from b in Bill,
    join: following in UserBill, on: b.id == following.bill_id,
    where: following.user_id == ^user_id,
    preload: [:top_subject]
  end

  def following_ids(user_id) do
    __MODULE__.following_query(user_id)
    |> Repo.all
    |> Enum.map(&(&1.id))
  end

end
