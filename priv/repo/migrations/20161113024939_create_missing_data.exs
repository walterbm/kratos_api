defmodule KratosApi.Repo.Migrations.CreateMissingData do
  use Ecto.Migration

  def change do
    create table(:missing_data) do
      add :type, :string
      add :govtrack_id, :integer
      add :caller, :string
      add :caller_id, :integer
      add :collected, :boolean, default: false, null: false

      timestamps()
    end

  end
end
