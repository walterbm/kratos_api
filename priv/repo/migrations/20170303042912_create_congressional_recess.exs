defmodule KratosApi.Repo.Migrations.CreateCongressionalRecess do
  use Ecto.Migration

  def change do
    create table(:congressional_recess) do
      add :start_date, :date
      add :end_date, :date
      add :year, :integer

      timestamps()
    end

  end
end
