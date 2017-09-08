defmodule KratosApi.StateImage do
  use KratosApi.Web, :model

  @primary_key {:state, :string, []}
  schema "state_images" do
    field :image_url, :string

    timestamps()
  end

  def primary_key, do: elem(@primary_key, 0)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:state, :image_url])
    |> unique_constraint(:state, name: :state_images_pkey)
    |> unique_constraint(:state, name: :state_images_state_index)
    |> validate_required([:state, :image_url])
    |> validate_length(:state, is: 2)
  end
end
