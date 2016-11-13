defmodule KratosApi.Repo.Migrations.CreateBill do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :govtrack_id, :integer
      add :link, :string
      add :title_without_number, :string
      add :is_current, :boolean, default: false, null: false
      add :lock_title, :boolean, default: false, null: false
      add :senate_floor_schedule_postdate, :date
      add :sliplawnum, :integer
      add :bill_type, :string
      add :docs_house_gov_postdate, :date
      add :noun, :string
      add :current_status_date, :date
      add :source_link, :string
      add :current_status, :string
      add :introduced_date, :date
      add :bill_type_label, :string
      add :bill_resolution_type,:string
      add :display_number, :string
      add :title, :string
      add :sliplawpubpriv, :string
      add :current_status_label, :string
      add :is_alive, :boolean, default: false, null: false
      add :number, :integer
      add :source, :string
      add :current_status_description, :string
      add :titles, :map
      add :major_actions, :map
      add :related_bills, :map

      add :congress_number_id, references(:congress_numbers, on_delete: :nothing, column: :number)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:bills, [:govtrack_id], unique: true)

  end
end
