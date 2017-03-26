defmodule KratosApi.Repo.Migrations.CreateUserBill do
  use Ecto.Migration

  def change do
    create table(:user_bills) do
      add :user_id, references(:users, on_delete: :nothing)
      add :bill_id, references(:bills, on_delete: :nothing)

      timestamps()
    end
    create index(:user_bills, [:user_id])
    create index(:user_bills, [:bill_id])

  end
end
