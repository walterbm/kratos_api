defmodule KratosApi.Repo.Migrations.CreateNomination do
  use Ecto.Migration

  def change do
    create table(:nominations) do
      add :title, :text

      timestamps()
    end

  end
end
