defmodule KratosApi.UserAction do
  use KratosApi.Web, :model

  schema "user_actions" do
    field :action, :string
    belongs_to :user, KratosApi.User
    belongs_to :person, KratosApi.Person

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:action, :user_id, :person_id])
    |> validate_required([:action, :user_id, :person_id])
  end
end
