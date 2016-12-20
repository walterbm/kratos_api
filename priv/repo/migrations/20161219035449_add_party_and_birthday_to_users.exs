defmodule KratosApi.Repo.Migrations.AddPartyAndBirthdayToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :party, :string
      add :birthday, :date
    end
  end
end
