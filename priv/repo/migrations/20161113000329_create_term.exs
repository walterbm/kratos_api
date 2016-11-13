defmodule KratosApi.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :name, :string
      add :term_type, :string
      add :term_type_label, :string
      add :govtrack_id, :integer

      timestamps()
    end

    create index(:terms, [:govtrack_id], unique: true)

  end
end
