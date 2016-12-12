defmodule KratosApi.Repo.Migrations.CreatePersonCommittee do
  use Ecto.Migration

  def change do
    create table(:person_committees) do
      add :person_id, references(:persons, on_delete: :nothing)
      add :committee_code, references(:committees, on_delete: :nothing, column: :code, type: :string)
    end
    create index(:person_committees, [:person_id])
    create index(:person_committees, [:committee_code])

  end
end
