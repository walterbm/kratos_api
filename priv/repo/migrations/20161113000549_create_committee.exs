defmodule KratosApi.Repo.Migrations.CreateCommittee do
  use Ecto.Migration

  def change do
    create table(:committees) do
      add :type, :string
      add :name, :string
      add :thomas_id, :string
      add :senate_committee_id, :string
      add :house_committee_id, :string
      add :jurisdiction, :string
      add :jurisdiction_source, :string
      add :url, :string
      add :address, :string
      add :phone, :string
      add :rss_url, :string
      add :minority_rss_url, :string
      add :past_names, :map

      add :parent_id, references(:committees, on_delete: :nothing)

      timestamps()
    end

  end
end
