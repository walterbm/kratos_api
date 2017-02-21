defmodule KratosApi.Committee do
  use KratosApi.Web, :model

  schema "committees" do
    field :type, :string
    field :name, :string
    field :thomas_id, :string
    field :senate_committee_id, :string
    field :house_committee_id, :string
    field :jurisdiction, :string
    field :jurisdiction_source, :string
    field :url, :string
    field :address, :string
    field :phone, :string
    field :rss_url, :string
    field :minority_rss_url, :string
    field :minority_url, :string
    field :past_names, :map

    has_many :members, KratosApi.CommitteeMember, on_replace: :delete

    timestamps()
  end


  @required_fields []
  @allowed_fields ~w(type name thomas_id senate_committee_id house_committee_id jurisdiction jurisdiction_source url
    address phone rss_url minority_rss_url minority_url past_names)a

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
    |> put_assoc(:members, KratosApi.Model.Utils.append_current(:members, struct, params))
  end
end
