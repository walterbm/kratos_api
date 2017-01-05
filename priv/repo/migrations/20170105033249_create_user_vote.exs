defmodule KratosApi.Repo.Migrations.CreateUserVote do
  use Ecto.Migration

  def change do
    create table(:user_votes) do
      add :value, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :tally_id, references(:tallies, on_delete: :nothing)

      timestamps()
    end
    create index(:user_votes, [:user_id])
    create index(:user_votes, [:tally_id])

  end
end
