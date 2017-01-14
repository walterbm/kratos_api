defmodule KratosApi.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:terms) do
      add :type, :string
      add :start, :date
      add :end, :date
      add :state, :string
      add :district, :integer
      add :class, :string
      add :state_rank, :string
      add :party, :string
      add :caucus, :string
      add :party_affiliations, :map
      add :url, :string
      add :address, :string
      add :phone, :string
      add :fax, :string
      add :contact_form, :string
      add :office, :string
      add :rss_url, :string

      add :person_id, references(:persons, on_delete: :nothing)

      timestamps()
    end

    create index(:terms, [:person_id])

  end
end
