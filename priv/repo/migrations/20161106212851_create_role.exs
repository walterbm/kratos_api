defmodule KratosApi.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :current, :boolean, default: false, null: false
      add :enddate, :date
      add :description, :string
      add :govtrack_id, :integer
      add :caucus, :string
      add :district, :integer
      add :extra, :map
      add :leadership_title, :string
      add :party, :string
      add :phone, :string
      add :role_type, :string
      add :role_type_label, :string
      add :senator_class, :string
      add :senator_class_label, :string
      add :senator_rank, :string
      add :senator_rank_label, :string
      add :startdate, :date
      add :state, :string
      add :title, :string
      add :title_long, :string
      add :website, :string

      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end

    create index(:roles, [:govtrack_id], unique: true)

  end
end
