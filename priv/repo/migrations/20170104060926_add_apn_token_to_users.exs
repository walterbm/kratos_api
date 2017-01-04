defmodule KratosApi.Repo.Migrations.AddApnTokenToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :apn_token, :string
    end
  end
end
