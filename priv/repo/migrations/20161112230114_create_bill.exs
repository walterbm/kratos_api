defmodule KratosApi.Repo.Migrations.CreateBill do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :actions, :map
      add :amendments, :map
      add :gpo_id, :string
      add :pretty_gpo, :string
      add :type, :string
      add :committee_history, :map
      add :enacted_as, :map
      add :active, :boolean
      add :awaiting_signature, :boolean
      add :enacted, :boolean
      add :vetoed, :boolean
      add :history, :map
      add :introduced_at, :date
      add :number, :string
      add :official_title, :text
      add :popular_title, :text
      add :short_title, :text
      add :status, :string
      add :status_at, :utc_datetime
      add :summary_text, :text
      add :summary_date, :utc_datetime
      add :titles, :map
      add :gpo_data_updated_at, :utc_datetime
      add :source_url, :string
      add :full_text_url, :string
      add :md5_of_body, :string

      add :congress_number_id, references(:congress_numbers, on_delete: :nothing, column: :number)
      add :top_subject_id, references(:subjects, on_delete: :nothing)
      add :sponsor_id, references(:persons, on_delete: :nothing)

      timestamps()
    end

    create index(:bills, [:gpo_id], unique: true)
    create index(:bills, [:md5_of_body], unique: true)

  end
end
