defmodule KratosApi.Bill do
  use KratosApi.Web, :model

  schema "bills" do

    field :actions, {:array, :map}
    field :amendments, {:array, :map}
    field :gpo_id, :string
    field :type, :string
    field :committee_history, {:array, :map}
    field :enacted_as, :string
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
    field :status_at, Ecto.Date
    field :top_term, :string
    field :summary_text, :string
    field :summary_date, Ecto.DateTime
    field :titles, {:array, :map}
    field :gpo_data_updated_at, Ecto.DateTime
    field :urls, {:array, :string}
    field :md5_of_body, :string

    belongs_to :congress_number, KratosApi.CongressNumber, references: :number
    belongs_to :sponsor, KratosApi.Person

    has_many :related_bills, KratosApi.RelatedBill

    many_to_many :committees, KratosApi.Committee, join_through: "bill_committees"
    many_to_many :cosponsors, KratosApi.Person, join_through: "bill_cosponsors", join_keys: [bill_id: :id, cosponsor_id: :id]
    many_to_many :subjects, KratosApi.Subject, join_through: "bill_subjects"

    timestamps()
  end

  @required_fields ~w(gpo_id)
  @optional_fields ~w(actions amendments gpo_id type committee_history enacted_as active awaiting_signature
    enacted vetoed history introduced_at number official_title popular_title short_title
    status status_at top_term summary_text summary_date titles gpo_data_updated_at urls md5_of_body)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

end
