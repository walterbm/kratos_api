defmodule KratosApi.Repo.Migrations.CreateFloorActivity do
  use Ecto.Migration

  def change do
    create table(:flooractivities) do
      add :chamber, :string
      add :title, :string
      add :description, :string
      add :link, :string
      add :day, :date
      add :bill_id, references(:bills, on_delete: :nothing)

      timestamps()
    end
    create index(:flooractivities, [:bill_id])
    create index(:flooractivities, [:day])

  end
end
