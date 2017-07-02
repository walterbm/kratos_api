defmodule KratosApi.FloorActivity do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    FloorActivity
  }

  schema "flooractivities" do
    field :chamber, :string
    field :title, :string
    field :active, :boolean
    field :published_at, Ecto.DateTime
    field :md5, :string
    field :bill_gpo_id, :string
    belongs_to :bill, KratosApi.Bill

    timestamps()
  end

  @required_fields ~w(chamber title published_at md5 bill_gpo_id)a
  @allowed_fields ~w(chamber title active published_at md5 bill_id bill_gpo_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def on_this_date(chamber, date) do
    start_time = Ecto.DateTime.cast!(date <> " 00:00:00")
    end_time = Ecto.DateTime.cast!(date <> " 23:59:59")

    query =
      from activity in FloorActivity,
      where: activity.chamber == ^chamber,
      where: activity.published_at >= ^start_time
        and activity.published_at <= ^end_time,
      order_by: [desc: activity.published_at]

    Repo.all(query)
  end

  def active(chamber) do
    query =
      from activity in FloorActivity,
      where: activity.chamber == ^chamber,
      where: activity.active == true,
      order_by: [desc: activity.published_at]

    Repo.all(query)
  end

  def delete_all(chamber) do
    query =
      from activity in FloorActivity,
      where: activity.chamber == ^chamber

    Repo.delete_all(query)
  end
end
