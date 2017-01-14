defmodule KratosApi.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :first_name, :string
      add :last_name, :string
      add :phone, :bigint
      add :apn_token, :string
      add :party, :string
      add :birthday, :date
      add :address, :string
      add :city, :string
      add :state, :string
      add :zip, :integer
      add :district, :integer
      add :encrypted_password, :string, null: false

      timestamps()
    end

    create index(:users, [:email], unique: true)
    create index(:users, [:phone], unique: true)
    create index(:users, [:apn_token], unique: true)

  end
end
