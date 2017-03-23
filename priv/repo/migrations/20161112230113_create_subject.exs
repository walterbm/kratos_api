defmodule KratosApi.Repo.Migrations.CreateSubject do
  use Ecto.Migration

  def change do
    create table(:subjects) do
      add :name, :text

      timestamps()
    end

  end
end
