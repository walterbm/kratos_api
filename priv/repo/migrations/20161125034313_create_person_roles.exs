defmodule KratosApi.Repo.Migrations.CreatePersonRoles do
  use Ecto.Migration

  def change do
    create table(:person_roles) do
      add :person_id, references(:persons, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end
    create index(:person_roles, [:person_id])
    create index(:person_roles, [:role_id])

  end
end
