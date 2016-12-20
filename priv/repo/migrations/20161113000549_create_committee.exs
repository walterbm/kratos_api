defmodule KratosApi.Repo.Migrations.CreateCommittee do
  use Ecto.Migration

  def change do
    create table(:committees) do
      add :code, :string
      add :abbrev, :string
      add :name, :text
      add :govtrack_id, :integer
      add :committee_type, :string
      add :committee_type_label, :string
      add :jurisdiction, :text
      add :jurisdiction_link, :string
      add :obsolete, :boolean, default: false, null: false
      add :url, :string

      add :parent_id, references(:committees, on_delete: :nothing)

      timestamps()
    end

    create index(:committees, [:govtrack_id], unique: true)
    create index(:committees, [:code], unique: true)

  end
end
