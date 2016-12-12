defmodule KratosApi.Repo.Migrations.CreateBillCommittee do
  use Ecto.Migration

  def change do
    create table(:bill_committees) do
      add :bill_id, references(:bills, on_delete: :nothing)
      add :committee_code, references(:committees, on_delete: :nothing, column: :code, type: :string)
    end
    create index(:bill_committees, [:bill_id])
    create index(:bill_committees, [:committee_code])

  end
end
