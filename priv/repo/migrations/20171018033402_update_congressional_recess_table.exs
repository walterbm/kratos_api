defmodule KratosApi.Repo.Migrations.UpdateCongressionalRecessTable do
  use Ecto.Migration

  def change do
    alter table(:congressional_recess) do
      add :chamber, :string
    end

    create index(:congressional_recess, [:chamber])
  end
end
