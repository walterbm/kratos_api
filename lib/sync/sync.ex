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
        {:ok, producer} = GenStage.start_link(Sync.Bill.Producer, 0)
        {:ok, processor} = GenStage.start_link(Sync.Bill.Processor, 0)
        {:ok, consumer} = GenStage.start_link(Sync.Bill.Consumer, :ok)

        GenStage.sync_subscribe(processor, to: producer, max_demand: 1)
        GenStage.sync_subscribe(consumer, to: processor, max_demand: 1)
      :tally ->
        {:ok, producer} = GenStage.start_link(Sync.Tally.Producer, 0)
        {:ok, processor} = GenStage.start_link(Sync.Tally.Processor, 0)
        {:ok, consumer} = GenStage.start_link(Sync.Tally.Consumer, :ok)

        GenStage.sync_subscribe(processor, to: producer, max_demand: 1)
        GenStage.sync_subscribe(consumer, to: processor, max_demand: 1)
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
