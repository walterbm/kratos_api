defmodule KratosApi.Repo.Migrations.AddConfirmedToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :confirmed_email_at, :utc_datetime
    end
  end
end
