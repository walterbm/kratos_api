defmodule KratosApi.Repo.Migrations.UsersRemoveNotNullConstraint do
  use Ecto.Migration

  def up do
    alter table(:users) do
      modify :first_name, :string, null: true
      modify :last_name, :string, null: true
      modify :phone, :bigint, null: true
      modify :email, :string, null: false
      modify :apn_token, :string, null: false
    end

    create index(:users, [:apn_token], unique: true)
  end

  def down do
    alter table(:users) do
      modify :first_name, :string, null: true
      modify :last_name, :string, null: true
      modify :phone, :bigint, null: true
      modify :email, :string, null: false
      modify :apn_token, :string, null: false
    end

    drop index(:users, [:apn_token], unique: true)
  end


end
