defmodule KratosApi.FileHash do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    FileHash
  }

  schema "filehashes" do
    field :hash, :string
    field :file, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hash, :file])
    |> validate_required([:hash, :file])
  end

  def exists?(hash, file_name) do
    case FileHash |> Repo.get_by(hash: hash) do
      nil ->
        Repo.insert(%FileHash{hash: hash, file: file_name})
        {:ok, :new}
      _ ->
        {:ok, :exists}
    end
  end
end
