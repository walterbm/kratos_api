defmodule KratosApi.Repo.Migrations.CreateFec do
  use Ecto.Migration

  def change do
    create table(:fec) do
      add :number, :string
      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end
    create index(:fec, [:person_id])
  end

end
