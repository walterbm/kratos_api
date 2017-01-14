defmodule KratosApi.Repo.Migrations.UsersRemoveApnTokenRequirement do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :apn_token, :string, null: true
    end
  end

  def down do
    alter table(:users) do
      modify :apn_token, :string, null: false
    end
  end
end
