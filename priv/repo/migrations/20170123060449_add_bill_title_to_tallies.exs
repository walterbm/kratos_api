defmodule KratosApi.Repo.Migrations.AddBillTitleToTallies do
  use Ecto.Migration

  def change do
    alter table(:tallies) do
      add :bill_short_title, :string
      add :bill_official_title, :string
    end
  end
end
