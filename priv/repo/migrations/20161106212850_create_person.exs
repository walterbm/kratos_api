defmodule KratosApi.Repo.Migrations.CreatePerson do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :govtrack_id, :integer
      add :cspanid, :integer
      add :bioguideid, :string
      add :birthday, :date
      add :firstname, :string
      add :gender, :string
      add :gender_label, :string
      add :lastname, :string
      add :link, :string
      add :middlename, :string
      add :name, :string
      add :namemod, :string
      add :nickname, :string
      add :osid, :string
      add :pvsid, :string
      add :sortname, :string
      add :twitterid, :string
      add :youtubeid, :string
      add :image_url, :string

      timestamps()
    end

    create index(:persons, [:govtrack_id], unique: true)

  end
end
