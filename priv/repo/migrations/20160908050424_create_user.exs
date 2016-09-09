defmodule KratosApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone, :bigint, null: false
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :integer
      add :district, :integer
      add :encrypted_password, :string, null: false

      timestamps()
    end

    create index(:users, [:phone], unique: true)

  end
end
