defmodule KratosApi.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    drop index(:users, [:apn_token], unique: true)
  end
end
