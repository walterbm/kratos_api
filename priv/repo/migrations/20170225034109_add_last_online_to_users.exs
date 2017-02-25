defmodule KratosApi.Repo.Migrations.AddLastOnlineToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :last_online_at, :utc_datetime
    end
  end
end
