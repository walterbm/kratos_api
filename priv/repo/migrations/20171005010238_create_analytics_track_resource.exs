defmodule KratosApi.Repo.Migrations.CreateAnalyticsTrackResource do
  use Ecto.Migration

  def change do
    create table(:analytics_track_resources) do
      add :resource_type, :string
      add :resource_id, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:analytics_track_resources, [:user_id])
  end
end
