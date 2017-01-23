defmodule KratosApi.Repo.Migrations.BumpBillFieldsToTextInTallies do
  use Ecto.Migration

  def change do
    alter table(:tallies) do
      modify :bill_short_title, :text
      modify :bill_official_title, :text
    end
  end
end
