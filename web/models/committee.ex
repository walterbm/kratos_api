defmodule KratosApi.Committee do
  use KratosApi.Web, :model

  schema "committees" do
    field :url, :string
    field :obsolete, :boolean, default: false
    field :name, :string
    field :jurisdiction_link, :string
    field :jurisdiction, :string
    field :govtrack_id, :integer
    field :committee_type_label, :string
    field :committee_type, :string
    field :committee, :string
    field :code, :string
    field :abbrev, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :obsolete, :name, :jurisdiction_link, :jurisdiction, :govtrack_id, :committee_type_label, :committee_type, :committee, :code, :abbrev])
    |> validate_required([:url, :obsolete, :name, :jurisdiction_link, :jurisdiction, :govtrack_id, :committee_type_label, :committee_type, :committee, :code, :abbrev])
  end

  def find_or_create(committee) do
    committee = KratosApi.Committee |> KratosApi.Repo.get_by(govtrack_id: committee["id"])
    if !committee do
      %KratosApi.Committee{url: committee["url"], obsolete: committee["obsolete"], name: committee["name"], jurisdiction_link: committee["jurisdiction_link"],
        jurisdiction: committee["jurisdiction"], govtrack_id: committee["id"], committee_type_label: committee["committee_type_label"],
        committee_type: committee["committee_type"], committee: committee["committee"], code: committee["code"], abbrev: committee["abbrev"]}
       |> KratosApi.Repo.insert
    else
      committee
    end
  end

end
