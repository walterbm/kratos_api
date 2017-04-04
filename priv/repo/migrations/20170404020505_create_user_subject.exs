defmodule KratosApi.Repo.Migrations.CreateUserSubject do
  use Ecto.Migration

  def change do
    create table(:user_subjects) do
      add :user_id, references(:users, on_delete: :nothing)
      add :subject_id, references(:subjects, on_delete: :nothing)

      timestamps()
    end
    create index(:user_subjects, [:user_id])
    create index(:user_subjects, [:subject_id])

  end
end
