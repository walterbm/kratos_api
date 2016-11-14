defmodule KratosApi.Repo.Migrations.CreateTally do
  use Ecto.Migration

  def change do
    create table(:tallies) do
      add :created, :datetime
      add :govtrack_id, :integer
      add :key, :string
      add :value, :string
      add :voter_type, :string
      add :voter_type_label, :string
      add :voteview_extra_code, :string
      add :person_id, references(:roles, on_delete: :nothing)
      add :vote_id, references(:votes, on_delete: :nothing)

      timestamps()
    end
    create index(:tallies, [:person_id])
    create index(:tallies, [:vote_id])

  end
end
