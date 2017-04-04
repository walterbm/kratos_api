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
end
