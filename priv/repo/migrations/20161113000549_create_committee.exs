defmodule KratosApi.Repo.Migrations.CreateCommittee do
  use Ecto.Migration

  def change do
    create table(:committees, primary_key: false) do
      add :code, :string, primary_key: true
      add :abbrev, :string
      add :name, :string
      add :govtrack_id, :integer
      add :committee_type, :string
      add :committee_type_label, :string
      add :jurisdiction, :text
      add :jurisdiction_link, :string
      add :obsolete, :boolean, default: false, null: false
      add :url, :string

      add :parent_code, references(:committees, on_delete: :nothing, column: :code, type: :string)

      timestamps()
    end

    create index(:committees, [:govtrack_id], unique: true)

  end
end
