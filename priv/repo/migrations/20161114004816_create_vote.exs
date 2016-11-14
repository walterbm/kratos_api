defmodule KratosApi.Repo.Migrations.CreateVote do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :govtrack_id, :integer
      add :category, :string
      add :category_label, :string
      add :chamber, :string
      add :created, :datetime
      add :link, :string
      add :margin, :float
      add :missing_data, :boolean, default: false, null: false
      add :number, :integer
      add :percent_plus, :float
      add :question, :string
      add :question_details, :string
      add :required, :string
      add :result, :string
      add :session, :string
      add :source, :string
      add :source_label, :string
      add :total_minus, :integer
      add :total_other, :integer
      add :total_plus, :integer
      add :vote_type, :string
      add :related_amendment, :integer

      add :congress_number_id, references(:congress_numbers, on_delete: :nothing, column: :number)
      add :related_bill_id, references(:bills, on_delete: :nothing)

      timestamps()
    end
    create index(:votes, [:congress_number_id])
    create index(:votes, [:related_bill_id])
    create index(:votes, [:govtrack_id], unique: true)


  end
end
