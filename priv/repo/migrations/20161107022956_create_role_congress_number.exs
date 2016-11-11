defmodule KratosApi.Repo.Migrations.CreateRoleCongressNumber do
  use Ecto.Migration

  def change do
    create table(:role_congress_numbers) do
      add :role_id, references(:roles, on_delete: :nothing)
      add :congress_number_id, references(:congress_numbers, on_delete: :nothing, column: :number)
    end
    create index(:role_congress_numbers, [:role_id])
    create index(:role_congress_numbers, [:congress_number_id])

  end
end
