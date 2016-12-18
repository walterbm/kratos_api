defmodule KratosApi.Tally do
  use KratosApi.Web, :model

  schema "tallies" do
    field :amendment, :map
    field :treaty, :map
    field :category, :string
    field :chamber, :string
    field :date, Ecto.DateTime
    field :number, :integer
    field :question, :string
    field :requires, :string
    field :result, :string
    field :result_text, :string
    field :session, :string
    field :source_url, :string
    field :subject, :string
    field :type, :string
    field :record_updated_at, Ecto.DateTime
    field :gpo_id, :string
    field :md5_of_body, :string

    belongs_to :bill, KratosApi.Bill
    belongs_to :nomination, KratosApi.Nomination
    belongs_to :congress_number, KratosApi.CongressNumber, references: :number

    has_many :votes, KratosApi.Vote

    timestamps()
  end

  @required_fields ~w(gpo_id)
  @optional_fields ~w(amendment treaty category chamber date number question requires result result_text session source_url subject type record_updated_at md5_of_body)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end
  
end
