defmodule KratosApi.Analytics.TrackResource do
  use Ecto.Schema
  import Ecto.Changeset
  alias KratosApi.Analytics.TrackResource


  schema "analytics_track_resources" do
    field :resource_id, :integer
    field :resource_type, :string
    field :user_id, :id

    timestamps()
  end

  @required_fields ~w(resource_type resource_id user_id)a
  @allowed_fields ~w(resource_type resource_id user_id)a

  @doc false
  def changeset(%TrackResource{} = track_resource, attrs) do
    track_resource
    |> cast(attrs, @required_fields)
    |> validate_required(@allowed_fields)
  end
end
