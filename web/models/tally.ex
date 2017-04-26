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
    field :bill_short_title, :string
    field :bill_official_title, :string
    field :bill_pretty_gpo, :string
    field :md5_of_body, :string

    belongs_to :bill, KratosApi.Bill
    belongs_to :nomination, KratosApi.Nomination
    belongs_to :congress_number, KratosApi.CongressNumber, references: :number

    has_many :votes, KratosApi.Vote

    many_to_many :subjects, KratosApi.Subject, join_through: "bill_subjects", join_keys: [bill_id: :bill_id, subject_id: :id]

    timestamps()
  end

  @required_fields ~w()a
  @allowed_fields ~w(gpo_id amendment treaty category chamber date number question requires result result_text
    session source_url subject type record_updated_at bill_short_title  bill_official_title bill_pretty_gpo md5_of_body)a

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
  end

  def tallyup_votes(votes) do
    Enum.reduce(votes, %{}, fn (vote, acc) ->
      Map.put(acc, vote.value, Map.get(acc, vote.value, 0) + 1)
    end)
  end

end
