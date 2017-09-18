defmodule KratosApi.Bill do
  use KratosApi.Web, :model

  alias KratosApi.{
    Repo,
    UserBill,
    UserSubject,
    TrendingBill,
    FloorActivity,
  }

  schema "bills" do

    field :actions, {:array, :map}
    field :amendments, {:array, :map}
    field :gpo_id, :string
    field :pretty_gpo, :string
    field :type, :string
    field :committee_history, {:array, :map}
    field :enacted_as, :map
    field :active, :boolean
    field :awaiting_signature, :boolean
    field :enacted, :boolean
    field :vetoed, :boolean
    field :history, :map
    field :introduced_at, Ecto.Date
    field :number, :string
    field :official_title, :string
    field :popular_title, :string
    field :short_title, :string
    field :status, :string
    field :status_at, Ecto.DateTime
    field :summary_text, :string
    field :summary_date, Ecto.DateTime
    field :titles, {:array, :map}
    field :gpo_data_updated_at, Ecto.DateTime
    field :source_url, :string
    field :full_text_url, :string
    field :md5_of_body, :string

    belongs_to :congress_number, KratosApi.CongressNumber, references: :number
    belongs_to :sponsor, KratosApi.Person
    belongs_to :top_subject, KratosApi.Subject

    has_many :related_bills, KratosApi.RelatedBill, on_replace: :delete
    has_many :tallies, KratosApi.Tally, on_replace: :delete

    many_to_many :committees, KratosApi.Committee, join_through: "bill_committees"
    many_to_many :cosponsors, KratosApi.Person, join_through: "bill_cosponsors", join_keys: [bill_id: :id, cosponsor_id: :id]
    many_to_many :subjects, KratosApi.Subject, join_through: "bill_subjects"

    timestamps()
  end

  @required_fields ~w(gpo_id)a
  @allowed_fields ~w(gpo_id pretty_gpo actions amendments gpo_id type committee_history enacted_as active awaiting_signature
    enacted vetoed history introduced_at number official_title popular_title short_title
    status status_at summary_text summary_date titles gpo_data_updated_at source_url full_text_url md5_of_body)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def update(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> put_assoc(:related_bills, KratosApi.Model.Utils.append_current(:related_bills, struct, params, :related_bill_id))
    |> put_assoc(:tallies, KratosApi.Model.Utils.append_current(:tallies, struct, params, :gpo_id))
  end

  def query_all(%{"subjects" => subjects}) do
    from b in __MODULE__,
    where: b.top_subject_id in ^subjects,
    preload: [:top_subject],
    order_by: [desc: b.introduced_at]
  end
  def query_all(_) do
    from b in __MODULE__,
    preload: [:top_subject],
    order_by: [desc: b.introduced_at]
  end

  def query_sponsored(%{"id" => id}) do
    from b in __MODULE__,
    where: b.sponsor_id == ^id,
    preload: [:top_subject]
  end

  def active_in(chamber) do
    query =
      from bill in __MODULE__,
      join: activity in FloorActivity,
      where: activity.bill_id == bill.id,
      where: activity.chamber == ^chamber,
      where: activity.active == true,
      preload: [:top_subject],
      order_by: [desc: activity.published_at]

    Repo.all(query)
  end

  def trending() do
    query =
      from bill in __MODULE__,
      join: tb in TrendingBill,
      where: tb.bill_id == bill.id,
      preload: [:top_subject],
      order_by: [desc: tb.updated_at]

    Repo.all(query)
  end

  def query_mine(_user_id, %{"subjects" => ["false"], "userbills" => "false"}) do
    from b in base(),
    where: b.id == 0
  end
  def query_mine(user_id, %{"subjects" => ["false"], "userbills" => "true"}) do
    from b in base(),
    join: following in UserBill, on: b.id == following.bill_id,
    where: following.user_id == ^user_id
  end
  def query_mine(_user_id, %{"subjects" => subjects, "userbills" => "false"}) do
    from b in base(),
    where: b.top_subject_id in ^subjects
  end
  def query_mine(user_id, %{"subjects" => subjects, "userbills" => "true"}) do
    from b in base(),
    where: b.top_subject_id in ^subjects,
    left_join: following in UserBill, on: b.id == following.bill_id,
    or_where: following.user_id == ^user_id
  end
  def query_mine(user_id, _params) do
    from b in base(),
    left_join: subject in UserSubject, on: b.top_subject_id == subject.id,
    where: subject.user_id == ^user_id,
    left_join: following in UserBill, on: b.id == following.bill_id,
    or_where: following.user_id == ^user_id
  end

  def following_ids(user_id) do
    base()
    |> following_bills(user_id)
    |> Repo.all
    |> Enum.map(&(&1.id))
  end

  defp base do
    from b in __MODULE__,
    preload: [:top_subject],
    order_by: [desc: b.introduced_at]
  end

  defp following_bills(query, user_id) do
    from b in query,
    join: following in UserBill, on: b.id == following.bill_id,
    where: following.user_id == ^user_id
  end

end
