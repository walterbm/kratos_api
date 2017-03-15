defmodule KratosApi.User do
  use KratosApi.Web, :model

  @derive {
    Poison.Encoder,
    except: [:__meta__],
    only: [:id, :first_name, :last_name, :email, :phone, :address, :city, :zip, :state, :district, :party, :birthday, :apn_token]
  }

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :integer
    field :email, :string
    field :address, :string
    field :city, :string
    field :state, :string
    field :zip, :integer
    field :district, :integer
    field :encrypted_password, :string
    field :party, :string
    field :birthday, Ecto.Date
    field :apn_token, :string
    field :last_online_at, Ecto.DateTime
    field :confirmed_email_at, Ecto.DateTime
    field :password, :string, virtual: true

    has_many :votes, KratosApi.UserVote
    has_many :actions, KratosApi.UserAction

    timestamps()
  end

  @required_fields ~w(password email)a
  @allowed_fields ~w(password encrypted_password email phone address city zip state district first_name last_name party birthday apn_token)a
  @updated_fields ~w(password apn_token phone address city zip state district first_name last_name party birthday)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "Password does not match")
    |> validate_format(:email, ~r/@/)
    |> lower_case(:email)
    |> unique_constraint(:email, message: "An account with that email already exists")
    |> unique_constraint(:phone, message: "An account with that phone number already exists")
    |> unique_constraint(:apn_token, message: "An account with that APN token already exists")
    |> generate_encrypted_password
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @updated_fields)
    |> unique_constraint(:phone, message: "An account with that phone number already exists")
    |> unique_constraint(:apn_token, message: "An account with that APN token already exists")
    |> generate_encrypted_password
  end

  def reset_password_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:password])
    |> validate_length(:password, min: 8)
    |> generate_encrypted_password
  end

  def last_online_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:last_online_at])
  end

  def confirm_email_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:confirmed_email_at])
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        current_changeset
    end
  end

  defp lower_case(changeset, field) do
    lowered_field = case Map.get(changeset.changes, field) do
      nil   -> nil
      field -> String.downcase(field)
    end
    put_change(changeset, field, lowered_field)
  end

end
