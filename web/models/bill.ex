defmodule KratosApi.Bill do
  use KratosApi.Web, :model

  schema "bills" do

    field :actions, {:array, :map}
    field :amendments, {:array, :map}
    field :gpo_id, :string
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
  @allowed_fields ~w(gpo_id actions amendments gpo_id type committee_history enacted_as active awaiting_signature
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

end
