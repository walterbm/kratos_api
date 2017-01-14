defmodule KratosApi.Repo.Migrations.CreateUserAction do
  use Ecto.Migration

  def change do
    create table(:user_actions) do
      add :action, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :last_bill_id, references(:bills, on_delete: :nothing)
      add :last_bill_seen_at, :utc_datetime
      add :last_tally_id, references(:tallies, on_delete: :nothing)
      add :last_tally_seen_at, :utc_datetime

      timestamps()
    end
    create index(:user_actions, [:user_id])
    create index(:user_actions, [:last_bill_id])
    create index(:user_actions, [:last_tally_id])
    create index(:user_actions, [:action])

  end
end
