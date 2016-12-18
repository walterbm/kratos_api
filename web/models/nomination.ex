defmodule KratosApi.Nomination do
  use KratosApi.Web, :model

  alias KratosApi.{
    Nomination,
    Repo
  }

  schema "nominations" do
    field :title, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end

  def create(data), do: Repo.insert!(%Nomination{title: data["title"]})

end
