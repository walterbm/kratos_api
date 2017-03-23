defmodule KratosApi.Subject do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    Subject
  }

  schema "subjects" do
    field :name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def find_or_create(nil), do: find_or_create("Unknown")
  def find_or_create(data) do
    case Repo.get_by(Subject, name: data) do
      nil -> Repo.insert!(%Subject{name: data})
      subject -> subject
    end
  end
end
