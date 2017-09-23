defmodule KratosApi.Repo.Migrations.UpdateUsersTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :pin, :string, size: 6
    end

    create unique_index(:users, [:pin])
  end
end
