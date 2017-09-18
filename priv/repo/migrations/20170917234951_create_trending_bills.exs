defmodule KratosApi.Repo.Migrations.CreateTrendingBills do
  use Ecto.Migration

  def change do
    create table(:trending_bills) do
      add :source, :string
      add :md5, :string
      add :bill_id, references(:bills, on_delete: :nothing)

      timestamps()
    end

    create index(:trending_bills, [:bill_id])
  end
end
