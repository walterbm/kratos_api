defmodule Mix.Tasks.Sync.People do
  use Mix.Task

  @shortdoc "Sync People and Terms."
  def run(_) do
    Mix.Task.run "app.start"
    Mix.shell.error "=== SYNC ==="
    KratosApi.Sync.Person.sync
    KratosApi.Sync.Person.SocialMedia.sync
    Mix.shell.error "~~ALL PEOPLE + TERMS SYNCED & SAVED~~"
  end
end

defmodule Mix.Tasks.Sync.Comms do
  use Mix.Task

  @shortdoc "Sync Committees"
  def run(_) do
    Mix.Task.run "app.start"
    Mix.shell.error "=== SYNC ==="
    KratosApi.Sync.Committee.sync
    KratosApi.Sync.Committee.Membership.sync
    Mix.shell.error "~~ALL COMMITTESS SYNCED & SAVED~~"
  end
end

defmodule Mix.Tasks.Sync.Bills do
  use Mix.Task

  @shortdoc "Sync Bills"
  def run(_) do
    Mix.Task.run "app.start"
    Mix.shell.error "=== SYNC ==="
    KratosApi.Sync.Bill.sync
    Mix.shell.error "~~ALL BILLS SYNCED & SAVED~~"
  end
end

defmodule Mix.Tasks.Sync.Talls do
  use Mix.Task

  @shortdoc "Sync Tallies and Votes"
  def run(_) do
    Mix.Task.run "app.start"
    Mix.shell.error "=== SYNC ==="
    KratosApi.Sync.Tally.sync
    Mix.shell.error "~~ALL TALLIES + VOTES SYNCED & SAVED~~"
  end
end

defmodule Mix.Tasks.Sync.All do
  use Mix.Task

  @shortdoc "Sync Everything"
  def run(_) do
    Mix.Task.run "app.start"
    Mix.Task.run "sync.people"
    Mix.Task.run "sync.comms"
    Mix.Task.run "sync.bills"
    Mix.Task.run "sync.talls"
  end
end
