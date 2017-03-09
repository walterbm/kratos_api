defmodule KratosApi.Repo.Migrations.CreateStateImage do
  use Ecto.Migration

  def change do
    create table(:state_images, primary_key: false) do
      add :state, :string, primary_key: true
      add :image_url, :text

      timestamps()
    end
  end
end
