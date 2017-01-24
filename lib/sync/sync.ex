defmodule KratosApi.Sync do

  def sync(source \\ :all) do
    case source do
      :all ->
        KratosApi.Sync.Person.sync
        KratosApi.Sync.Person.sync(:historical)
        KratosApi.Sync.Person.SocialMedia.sync
        KratosApi.Sync.Committee.sync
        KratosApi.Sync.Committee.Membership.sync
        KratosApi.Sync.Bill.sync
        KratosApi.Sync.Tally.sync
      :queue ->
        IO.puts "STARTING BILL SYNC"
        KratosApi.Sync.Bill.sync
        IO.puts "FINISHED BILL SYNC"
        IO.puts "STARTING TALLY SYNC"
        KratosApi.Sync.Tally.sync
        IO.puts "FINISHED TALLY SYNC"
      :store ->
        KratosApi.Sync.Person.sync
        KratosApi.Sync.Person.sync(:historical)
        KratosApi.Sync.Person.SocialMedia.sync
        KratosApi.Sync.Committee.sync
        KratosApi.Sync.Committee.Membership.sync
      _ -> IO.puts "NO SYNC"
    end

  end

end


# @TODO
# ** (DBConnection.ConnectionError) tcp recv: connection timed out - :etimedout
#     (ecto) lib/ecto/adapters/postgres/connection.ex:99: Ecto.Adapters.Postgres.Connection.execute/4
#     (ecto) lib/ecto/adapters/sql.ex:243: Ecto.Adapters.SQL.sql_call/6
#     (ecto) lib/ecto/adapters/sql.ex:193: Ecto.Adapters.SQL.query!/5
#     (ecto) lib/ecto/adapters/postgres.ex:86: Ecto.Adapters.Postgres.insert_all/7
#     (ecto) lib/ecto/repo/schema.ex:52: Ecto.Repo.Schema.do_insert_all/7
#     (ecto) lib/ecto/association.ex:963: Ecto.Association.ManyToMany.on_repo_change/4
#     (ecto) lib/ecto/association.ex:330: anonymous fn/7 in Ecto.Association.on_repo_change/6
#     (elixir) lib/enum.ex:1755: Enum."-reduce/3-lists^foldl/2-0-"/3
#     (ecto) lib/ecto/association.ex:327: Ecto.Association.on_repo_change/6
#     (elixir) lib/enum.ex:1755: Enum."-reduce/3-lists^foldl/2-0-"/3
#     (ecto) lib/ecto/association.ex:293: Ecto.Association.on_repo_change/3
#     (ecto) lib/ecto/repo/schema.ex:609: Ecto.Repo.Schema.process_children/4
#     (ecto) lib/ecto/repo/schema.ex:676: anonymous fn/3 in Ecto.Repo.Schema.wrap_in_transaction/6
#     (ecto) lib/ecto/adapters/sql.ex:615: anonymous fn/3 in Ecto.Adapters.SQL.do_transaction/3
#     (db_connection) lib/db_connection.ex:1274: DBConnection.transaction_run/4
#     (db_connection) lib/db_connection.ex:1198: DBConnection.run_begin/3
#     (db_connection) lib/db_connection.ex:789: DBConnection.transaction/3
#     (kratos_api) lib/sync/sync.ex:52: KratosApi.SyncHelpers.save/2
#     (elixir) lib/enum.ex:1229: Enum."-map/2-lists^map/1-0-"/2
#     (elixir) lib/enum.ex:1229: Enum."-map/2-lists^map/1-0-"/2
#
