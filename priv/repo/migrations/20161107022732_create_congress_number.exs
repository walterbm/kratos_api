defmodule KratosApi.Repo.Migrations.CreateCongressNumber do
  use Ecto.Migration

  def change do
    create table(:congress_numbers, primary_key: false) do
      add :number, :integer, primary_key: true

      timestamps()
    end

  end
end
