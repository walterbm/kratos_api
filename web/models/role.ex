defmodule KratosApi.Role do
  use KratosApi.Web, :model

  schema "roles" do

    field :current, :boolean, default: false
    field :enddate, Ecto.Date
    field :description, :string
    field :govtrack_id, :integer
    field :caucus, :string
    field :district, :integer
    field :extra, :map
    field :leadership_title, :string
    field :party, :string
    field :bioguideid, :string
    field :birthday, Ecto.Date
    field :cspanid, :integer
    field :firstname, :string
    field :gender, :string
    field :gender_label,  :string
    field :lastname, :string
    field :link, :string
    field :middlename, :string
    field :name, :string
    field :namemod, :string
    field :nickname, :string
    field :osid, :string
    field :pvsid, :string
    field :sortname, :string
    field :twitterid, :string
    field :youtubeid, :string
    field :phone, :string
    field :role_type, :string
    field :role_type_label, :string
    field :senator_class, :string
    field :senator_class_label, :string
    field :senator_rank, :string
    field :senator_rank_label, :string
    field :startdate, Ecto.Date
    field :state, :string
    field :title, :string
    field :title_long, :string
    field :website, :string

    many_to_many :congress_numbers, KratosApi.CongressNumber, join_through: "role_congress_numbers", join_keys: [role_id: :id, congress_number_id: :number]

    timestamps()
  end

  @required_fields ~w(govtrack_id)
  @optional_fields ~w(current enddate description caucus district extra leadership_title party bioguideid birthday cspanid firstname gender gender_label lastname link middlename name namemod nickname osid pvsid sortname twitterid youtubeid phone role_type role_type_label senator_class senator_class_label senator_rank senator_rank_label startdate state title title_long website)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def find_or_mark(role_id, caller, caller_id) do
    role = KratosApi.Role |> KratosApi.Repo.get_by(govtrack_id: role_id)
    if !role do
      KratosApi.Repo.insert(%KratosApi.MissingData{type: "role", govtrack_id: role_id, caller: caller, caller_id: caller_id})
      nil
    else
      role
    end
  end

  def find_or_create(data) do
    role = KratosApi.Role |> KratosApi.Repo.get_by(govtrack_id: data["id"])
    if !role do
      KratosApi.Sync.Role.save(data)
      nil
    else
      role
    end
  end
end
