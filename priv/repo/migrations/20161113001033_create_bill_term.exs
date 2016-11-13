defmodule KratosApi.Repo.Migrations.CreateBillTerm do
  use Ecto.Migration

  def change do
    create table(:bill_terms) do
      add :bill_id, references(:bills, on_delete: :nothing)
      add :term_id, references(:terms, on_delete: :nothing)

      timestamps()
    end
    create index(:bill_terms, [:bill_id])
    create index(:bill_terms, [:term_id])

  end
end
