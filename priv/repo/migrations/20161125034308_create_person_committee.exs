defmodule KratosApi.Repo.Migrations.CreatePersonCommittee do
  use Ecto.Migration

  def change do
    create table(:person_committees) do
      add :person_id, references(:persons, on_delete: :nothing)
      add :committee_id, references(:committees, on_delete: :nothing)

      timestamps()
    end
    create index(:person_committees, [:person_id])
    create index(:person_committees, [:committee_id])

  end
end
