defmodule KratosApi.Repo.Migrations.CreateCommiteeMember do
  use Ecto.Migration

  def change do
    create table(:commitee_members) do
      add :title, :string
      add :committee_id, references(:committees, on_delete: :nothing)
      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end
    create index(:commitee_members, [:committee_id])
    create index(:commitee_members, [:person_id])

  end
end
