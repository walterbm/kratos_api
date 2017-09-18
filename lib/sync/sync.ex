defmodule KratosApi.Sync do

  alias KratosApi.Sync

  @slack Application.get_env(:kratos_api, :slack)

  def sync(source) do
    case source do
      :all ->
        sync(:person)
        sync(:committee)
        sync(:bill)
        sync(:tally)
        sync(:recess)
        sync(:floor)
        sync(:trending)
      :queue ->
        sync(:bill)
        sync(:tally)
      :store ->
        sync(:person)
        sync(:committee)
      :bill ->
        run_bills()
        @slack.notify("`Bill` data mounted and saved to database")
      :tally ->
        run_tallies()
        @slack.notify("`Tally` data mounted and saved to database")
      :person ->
        Sync.Person.sync(:historical)
        Sync.Person.sync(:executive)
        Sync.Person.sync
        Sync.Person.SocialMedia.sync
        Sync.Person.Bio.sync
        @slack.notify("`Person` data mounted and saved to database")
      :committee ->
        Sync.Committee.sync
        Sync.Committee.Membership.sync
        @slack.notify("`Committee` data mounted and saved to database")
      :recess ->
        Sync.Recess.sync
        @slack.notify("`Recess` data mounted and saved to database")
      :floor ->
        Sync.Floor.sync
        @slack.notify("`Floor` data mounted and saved to database")
      :trending ->
        Sync.Trending.sync
        @slack.notify("`Trending` data mounted and saved to database")
      _ -> IO.puts "NO SYNC"
    end
  end

  defp run_bills do
    {:ok, producer} = GenStage.start_link(Sync.Bill.Producer, 0)
    {:ok, processor} = GenStage.start_link(Sync.Bill.Processor, 0)
    {:ok, consumer} = GenStage.start_link(Sync.Bill.Consumer, :ok)

    Process.monitor(consumer)

    GenStage.sync_subscribe(processor, to: producer, max_demand: 1)
    GenStage.sync_subscribe(consumer, to: processor, max_demand: 1)

    receive do
      {:DOWN, _ref, :process, _from_pid, _reason} -> true
    end
  end

  defp run_tallies do
    {:ok, producer} = GenStage.start_link(Sync.Tally.Producer, 0)
    {:ok, processor} = GenStage.start_link(Sync.Tally.Processor, 0)
    {:ok, consumer} = GenStage.start_link(Sync.Tally.Consumer, :ok)

    Process.monitor(consumer)

    GenStage.sync_subscribe(processor, to: producer, max_demand: 1)
    GenStage.sync_subscribe(consumer, to: processor, max_demand: 1)

    receive do
      {:DOWN, _ref, :process, _from_pid, _reason} -> true
    end
  end

end
