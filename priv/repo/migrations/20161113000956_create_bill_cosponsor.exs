defmodule KratosApi.Repo.Migrations.CreateBillCosponsor do
  use Ecto.Migration

  def change do
    create table(:bill_cosponsors) do
      add :bill_id, references(:bills, on_delete: :nothing)
      add :cosponsor_id, references(:roles, on_delete: :nothing)

      timestamps()
    end
    create index(:bill_cosponsors, [:bill_id])
    create index(:bill_cosponsors, [:cosponsor_id])

  end
end
