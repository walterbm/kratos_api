defmodule KratosApi.Term do
  use KratosApi.Web, :model

  schema "terms" do

    field :type, :string # Either "sen" for senators or "rep" for representatives
    field :start, Ecto.Date
    field :end, Ecto.Date
    field :state, :string
    field :district, :integer
    field :class, :string
    field :state_rank, :string
    field :party, :string
    field :caucus, :string
    field :party_affiliations, :map
    field :url, :string
    field :address, :string
    field :phone, :string
    field :fax, :string
    field :contact_form, :string
    field :office, :string
    field :rss_url, :string
    field :is_current, :boolean, virtual: true

    belongs_to :person, KratosApi.Person

    timestamps()
  end



  @required_fields []
  @allowed_fields ~w(type start end state district class state_rank party caucus party_affiliations url address phone
    fax contact_form office rss_url is_current)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
  end

  def find_or_create(data) do
    # case Repo.get_by(Term, govtrack_id: data["id"]) do
    #   nil -> KratosApi.Sync.Term.save(data)
    #   role -> role
    # end
  end

end
