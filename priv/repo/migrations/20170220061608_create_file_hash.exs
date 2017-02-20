defmodule KratosApi.Repo.Migrations.CreateFileHash do
  use Ecto.Migration

  def change do
    create table(:filehashes) do
      add :hash, :text
      add :file, :string

      timestamps()
    end

    create index(:filehashes, [:hash], unique: true)
  end
end
