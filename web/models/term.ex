defmodule KratosApi.Term do
  use KratosApi.Web, :model

  schema "terms" do
    field :name, :string
    field :term_type, :string
    field :term_type_label, :string
    field :govtrack_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :term_type, :term_type_label, :govtrack_id])
    |> validate_required([:name, :term_type, :term_type_label, :govtrack_id])
  end

  def find_or_create(term) do
    term = KratosApi.Term |> KratosApi.Repo.get_by(govtrack_id: term["id"])
    if !term do
      %KratosApi.Term{term_type_label: term["term_type_label"], term_type: term["term_type"], name: term["name"], govtrack_id: term["id"]}
       |> KratosApi.Repo.insert
    else
      term
    end
  end
end
