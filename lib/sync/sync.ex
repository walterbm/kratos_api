defmodule KratosApi.Sync do

  alias KratosApi.Sync

  def sync(source \\ :all) do
    case source do
      :all ->
        sync(:person)
        sync(:committee)
        sync(:bill)
        sync(:tally)
      :queue ->
        sync(:bill)
        sync(:tally)
      :store ->
        sync(:person)
        sync(:committee)
      :bill ->
        Sync.Bill.sync
      :tally ->
        Sync.Tally.sync
      :person ->
        Sync.Person.sync
        Sync.Person.sync(:historical)
        Sync.Person.SocialMedia.sync
      :committee ->
        Sync.Committee.sync
        Sync.Committee.Membership.sync
      _ -> IO.puts "NO SYNC"
    end
  end

end
