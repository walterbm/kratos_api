defmodule KratosApi.User do
  use KratosApi.Web, :model

  @derive {
    Poison.Encoder,
    except: [:__meta__],
    only: [:id, :first_name, :last_name, :phone, :address, :city, :zip, :state, :district, :party, :birthday, :apn_token]
  }

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :integer
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :integer
    field :district, :integer
    field :encrypted_password, :string
    field :party, :string
    field :birthday, Ecto.Date
    field :apn_token, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(password phone)
  @optional_fields ~w(encrypted_password address city zip state district first_name last_name party birthday apn_token)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "Password does not match")
    |> unique_constraint(:phone, message: "Phone number is already taken")
    |> generate_encrypted_password
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end

end
