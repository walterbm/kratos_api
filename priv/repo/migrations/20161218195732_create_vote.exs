defmodule KratosApi.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :value, :string
      add :tally_id, references(:tallies, on_delete: :nothing)
      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end
    create index(:votes, [:tally_id])
    create index(:votes, [:person_id])

  end
end
