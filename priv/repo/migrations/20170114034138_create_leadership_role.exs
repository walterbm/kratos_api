defmodule KratosApi.Repo.Migrations.CreateLeadershipRole do
  use Ecto.Migration

  def change do
    create table(:leadership_roles) do
      add :title, :string
      add :chamber, :string
      add :start, :date
      add :end, :date
      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end
    create index(:leadership_roles, [:person_id])

  end
end
