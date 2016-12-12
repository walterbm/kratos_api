defmodule KratosApi.Subject do
  use KratosApi.Web, :model

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

  def find_or_create(data) do
    subject = KratosApi.Subject |> KratosApi.Repo.get_by(name: data)
    if !subject do
      {:ok, subject} = KratosApi.Repo.insert(%KratosApi.Subject{name: data})
      subject
    else
      subject
    end
  end
end
