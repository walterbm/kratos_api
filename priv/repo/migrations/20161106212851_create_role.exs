defmodule KratosApi.Repo.Migrations.CreateRole do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :current, :boolean, default: false, null: false
      add :enddate, :date
      add :description, :string
      add :govtrack_id, :integer
      add :caucus, :string
      add :district, :integer
      add :extra, :map
      add :leadership_title, :string
      add :party, :string
      add :bioguideid, :string
      add :birthday, :date
      add :cspanid, :integer
      add :firstname, :string
      add :gender, :string
      add :gender_label,  :string
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
      add :phone, :string
      add :role_type, :string
      add :role_type_label, :string
      add :senator_class, :string
      add :senator_class_label, :string
      add :senator_rank, :string
      add :senator_rank_label, :string
      add :startdate, :date
      add :state, :string
      add :title, :string
      add :title_long, :string
      add :website, :string

      timestamps()
    end

  end
end
