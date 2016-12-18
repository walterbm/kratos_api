defmodule KratosApi.Repo.Migrations.CreateRelatedBill do
  use Ecto.Migration

  def change do
    create table(:related_bills) do
      add :bill_id, references(:bills, on_delete: :nothing)
      add :related_bill_id, references(:bills, on_delete: :nothing)
      add :reason, :string
    end
    create index(:related_bills, [:bill_id])
    create index(:related_bills, [:related_bill_id])

  end
end
