defmodule KratosApi.Repo.Migrations.AddCurrentPartyToPersons do
  use Ecto.Migration

  def change do
    alter table(:persons) do
      add :current_party, :string
    end
  end
end
