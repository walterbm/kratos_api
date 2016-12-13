defmodule KratosApi.Repo.Migrations.CreateBillCommittee do
  use Ecto.Migration

  def change do
    create table(:bill_committees) do
      add :bill_id, references(:bills, on_delete: :nothing)
      add :committee_id, references(:committees, on_delete: :nothing)
    end
    create index(:bill_committees, [:bill_id])
    create index(:bill_committees, [:committee_id])

  end
end
