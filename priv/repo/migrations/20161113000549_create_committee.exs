defmodule KratosApi.Repo.Migrations.CreateCommittee do
  use Ecto.Migration

  def change do
    create table(:committees) do
      add :url, :string
      add :obsolete, :boolean, default: false, null: false
      add :name, :string
      add :jurisdiction_link, :string
      add :jurisdiction, :string
      add :govtrack_id, :integer
      add :committee_type_label, :string
      add :committee_type, :string
      add :committee, :string
      add :code, :string
      add :abbrev, :string

      timestamps()
    end

    create index(:committees, [:govtrack_id], unique: true)

  end
end
