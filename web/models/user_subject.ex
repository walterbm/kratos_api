defmodule KratosApi.UserSubject do
  use KratosApi.Web, :model

  schema "user_subjects" do
    belongs_to :user, KratosApi.User
    belongs_to :subject, KratosApi.Subject

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

  def get_or_create(user_id, subject_id) do
    case __MODULE__ |> KratosApi.Repo.get_by([user_id: user_id, subject_id: subject_id]) do
      nil -> KratosApi.Repo.insert!(%__MODULE__{subject_id: subject_id, user_id: user_id})
      user_subject -> user_subject
    end
  end
end
