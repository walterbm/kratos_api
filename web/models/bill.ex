defmodule KratosApi.Bill do
  use KratosApi.Web, :model

  schema "bills" do

    field :actions, {:array, {:array, :any}}
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
    field :related_bills, {:array, :map}
    field :short_title, :string
    field :status, :string
    field :status_at, Ecto.Date
    field :top_term, :string
    field :summary_text, :string
    field :summary_date, Ecto.DateTime
    field :titles, {:array, {:array, :string}}
    field :gpo_data_updated_at, Ecto.DateTime
    field :pdf_url, :string

    belongs_to :congress_number, KratosApi.CongressNumber, references: :number
    belongs_to :sponsor, KratosApi.Role

    many_to_many :committees, KratosApi.Committee, join_through: "bill_committees"
    many_to_many :cosponsors, KratosApi.Role, join_through: "bill_cosponsors"
    many_to_many :subjects, KratosApi.Term, join_through: "bill_subjects"

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(actions amendments gpo_id type committee_history enacted_as active awaiting_signature
    enacted vetoed history introduced_at number official_title popular_title related_bills short_title
    status status_at top_term summary_text summary_date titles gpo_data_updated_at pdf_url)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

end
