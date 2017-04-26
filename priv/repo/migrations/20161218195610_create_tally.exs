defmodule KratosApi.Repo.Migrations.CreateTally do
  use Ecto.Migration

  def change do
    create table(:tallies) do
      add :amendment, :map
      add :treaty, :map
      add :category, :string
      add :chamber, :string
      add :date, :utc_datetime
      add :number, :integer
      add :question, :text
      add :requires, :string
      add :result, :string
      add :result_text, :text
      add :session, :string
      add :source_url, :string
      add :subject, :text
      add :type, :string
      add :record_updated_at, :utc_datetime
      add :gpo_id, :string
      add :md5_of_body, :string
      add :bill_short_title, :text
      add :bill_official_title, :text
      add :bill_pretty_gpo, :string

      add :bill_id, references(:bills, on_delete: :nothing)
      add :nomination_id, references(:nominations, on_delete: :nothing)
      add :congress_number_id, references(:congress_numbers, on_delete: :nothing, column: :number)

      timestamps()
    end
    create index(:tallies, [:bill_id])
    create index(:tallies, [:nomination_id])
    create index(:tallies, [:congress_number_id])

  end
end
