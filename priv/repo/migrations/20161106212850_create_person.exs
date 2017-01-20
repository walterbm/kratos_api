defmodule KratosApi.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:persons) do

      add :bioguide, :string
      add :thomas, :string
      add :lis, :string
      add :opensecrets, :string
      add :votesmart, :string
      add :cspan, :string
      add :wikipedia, :string
      add :house_history, :string
      add :ballotpedia, :string
      add :maplight, :string
      add :icpsr, :string
      add :wikidata, :string
      add :google_entity_id, :string
      add :first_name, :string
      add :last_name, :string
      add :official_full_name, :string
      add :birthday, :date
      add :gender, :string
      add :religion, :string
      add :twitter, :string
      add :twitter_id, :string
      add :facebook, :string
      add :facebook_id, :string
      add :youtube, :string
      add :youtube_id, :string
      add :instagram, :string
      add :instagram_id, :string
      add :image_url, :string
      add :bio, :text

      timestamps()
    end

    create index(:persons, [:bioguide], unique: true)

  end
end
