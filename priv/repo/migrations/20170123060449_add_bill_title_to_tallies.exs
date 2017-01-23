defmodule KratosApi.Repo.Migrations.AddBillTitleToTallies do
  use Ecto.Migration

  def change do
    alter table(:tallies) do
      add :bill_title, :string
    end
  end
end
