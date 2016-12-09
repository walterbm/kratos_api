defmodule Mix.Tasks.SyncReps do
  use Mix.Task

  @shortdoc "Sync Roles and People."
  def run(_) do
    Mix.Task.run "app.start"
    Mix.shell.error "=== SYNC ==="
    KratosApi.Sync.Role.sync
      Mix.shell.error "~~ALL ROLES + PEOPLE SYNCED & SAVED~~"
  end
end

defmodule Mix.Tasks.SyncCom do
  use Mix.Task

  @shortdoc "Sync Committees"
  def run(_) do
    Mix.Task.run "app.start"
    Mix.shell.error "=== SYNC ==="
    KratosApi.Sync.Committee.sync
    Mix.shell.error "~~ALL COMMITTESS SYNCED & SAVED~~"
  end
end
