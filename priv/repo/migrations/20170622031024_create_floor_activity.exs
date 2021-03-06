defmodule KratosApi.Repo.Migrations.CreateFloorActivity do
  use Ecto.Migration

  def change do
    create table(:flooractivities) do
      add :chamber, :string
      add :title, :text
      add :active, :boolean, default: false, null: false
      add :published_at, :utc_datetime
      add :md5, :string
      add :bill_gpo_id, :string
      add :pretty_bill_gpo_id, :string
      add :bill_id, references(:bills, on_delete: :nothing)

      timestamps()
    end
    create index(:flooractivities, [:bill_id])

  end
end
