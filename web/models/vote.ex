defmodule KratosApi.Vote do
  use KratosApi.Web, :model

  schema "votes" do
    field :govtrack_id, :integer
    field :category, :string
    field :category_label, :string
    field :chamber, :string
    field :created, Ecto.DateTime
    field :link, :string
    field :margin, :float
    field :missing_data, :boolean, default: false
    field :number, :integer
    field :percent_plus, :float
    field :question, :string
    field :question_details, :string
    field :required, :string
    field :result, :string
    field :session, :string
    field :source, :string
    field :source_label, :string
    field :total_minus, :integer
    field :total_other, :integer
    field :total_plus, :integer
    field :vote_type, :string
    field :related_amendment, :integer

    belongs_to :congress_number, KratosApi.CongressNumber, references: :number
    belongs_to :related_bill, KratosApi.Bill, references: :bill_id

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(category category_label chamber created link margin missing_data
    number percent_plus question question_details required result session source
    source_label total_minus total_other total_plus vote_type related_amendment)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_mark(vote_id, caller, caller_id) do
    vote = KratosApi.Vote |> KratosApi.Repo.get_by(govtrack_id: vote_id)
    if !vote do
      KratosApi.Repo.insert(%KratosApi.MissingData{type: "vote", govtrack_id: vote_id, caller: caller, caller_id: caller_id})
      nil
    else
      vote
    end
  end

end
