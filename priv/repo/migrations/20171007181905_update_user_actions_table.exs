defmodule KratosApi.Repo.Migrations.UpdateUserActionsTable do
  use Ecto.Migration

  def change do
    alter table(:user_actions) do
      remove :last_bill_id
      remove :last_bill_seen_at
      remove :last_tally_id
      remove :last_tally_seen_at
    end
  end
end
