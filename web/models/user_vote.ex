defmodule KratosApi.UserVote do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    UserVote
  }

  schema "user_votes" do
    field :value, :string
    belongs_to :user, KratosApi.User
    belongs_to :tally, KratosApi.Tally

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:value])
    |> validate_required([:value])
  end

  def get_or_create(user_id, tally_id, value) do
    vote = case UserVote |> Repo.get_by([user_id: user_id, tally_id: tally_id]) do
      nil -> Repo.insert!(%UserVote{tally_id: tally_id, value: value, user_id: user_id})
      v -> v
    end

    vote |> Repo.preload([:tally])
  end
end
