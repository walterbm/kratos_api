defmodule KratosApi.Repo.Migrations.CreateCommitteeCongressNumbers do
  use Ecto.Migration

  def change do
    create table(:committee_congress_numbers) do
      add :committee_id, references(:committees, on_delete: :nothing)
      add :congress_number_id, references(:congress_numbers, on_delete: :nothing, column: :number)

      timestamps()
    end
    create index(:committee_congress_numbers, [:committee_id])
    create index(:committee_congress_numbers, [:congress_number_id])

  end
end
