defmodule KratosApi.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    rename table(:users), :apn_token, to: :push_token
  end
end
