defmodule KratosApi.Bill do
  use KratosApi.Web, :model

  schema "bills" do

    field :govtrack_id, :integer
    field :link, :string
    field :title_without_number, :string
    field :is_current, :boolean
    field :lock_title, :boolean
    field :senate_floor_schedule_postdate, Ecto.Date
    field :sliplawnum, :integer
    field :bill_type, :string
    field :docs_house_gov_postdate, Ecto.Date
    field :noun, :string
    field :current_status_date, Ecto.Date
    field :source_link, :string
    field :current_status, :string
    field :introduced_date, Ecto.Date
    field :bill_type_label, :string
    field :bill_resolution_type,:string
    field :display_number, :string
    field :title, :string
    field :sliplawpubpriv, :string
    field :current_status_label, :string
    field :is_alive, :boolean
    field :number, :integer
    field :source, :string
    field :current_status_description, :string
    field :titles, {:array, {:array, :string}}
    field :major_actions, {:array, {:array, :any}}
    field :related_bills, {:array, :map}

    belongs_to :congress_number, KratosApi.CongressNumber, references: :number
    belongs_to :sponsor, KratosApi.Role, foreign_key: :role_id

    many_to_many :committees, KratosApi.Committee, join_through: "bill_committees"
    many_to_many :cosponsors, KratosApi.Role, join_through: "bill_cosponsors"
    many_to_many :terms, KratosApi.Term, join_through: "bill_terms"

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(link title_without_number is_current lock_title senate_floor_schedule_postdate sliplawnum bill_type
    docs_house_gov_postdate noun current_status_date source_link current_status introduced_date bill_type_label
    bill_resolution_type display_number title sliplawpubpriv current_status_label is_alive number source
    current_status_description titles major_actions related_bills)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end
end
