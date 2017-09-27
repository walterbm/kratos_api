defmodule KratosApi.User do
  use KratosApi.Web, :model

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
    field :pin, :string
    field :push_token, :string
    field :last_online_at, Ecto.DateTime
    field :confirmed_email_at, Ecto.DateTime
    field :password, :string, virtual: true

    has_many :votes, KratosApi.UserVote
    has_many :actions, KratosApi.UserAction
    has_many :bills, KratosApi.UserBill

    timestamps()
  end

  @allowed_fields ~w(password encrypted_password email phone address city zip state district first_name last_name party birthday push_token)a
  @updated_fields ~w(password push_token phone address city zip state district first_name last_name party birthday)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(:password, message: "Password can't be blank.")
    |> validate_required(:email, message: "Email can't be blank.")
    |> validate_required(:address, message: "Address can't be blank.")
    |> validate_required(:city, message: "City can't be blank.")
    |> validate_required(:zip, message: "Zip code can't be blank.")
    |> validate_required(:state, message: "State can't be blank.")
    |> validate_required(:district, message: "District can't be blank.")
    |> validate_required(:first_name, message: "First name can't be blank.")
    |> validate_required(:last_name, message: "Last name can't be blank.")
    |> validate_required(:birthday, message: "Birthday can't be blank.")
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password, message: "Password does not match.")
    |> validate_format(:email, ~r/@/)
    |> lower_case(:email)
    |> unique_constraint(:email, message: "An account with that email already exists.")
    |> unique_constraint(:phone, message: "An account with that phone number already exists.")
    |> unique_constraint(:push_token, message: "An account with that push token already exists.")
    |> generate_unique_pin
    |> validate_length(:pin, is: 6)
    |> generate_encrypted_password
  end

  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @updated_fields)
    |> unique_constraint(:phone, message: "An account with that phone number already exists")
    |> unique_constraint(:push_token, message: "An account with that push token already exists")
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
    |> destroy_unique_pin
  end

  defp generate_encrypted_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end

  defp generate_unique_pin(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :pin, unique_pin())
      _ ->
        changeset
    end
  end

  defp destroy_unique_pin(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :pin, nil)
      _ ->
        changeset
    end
  end

  defp lower_case(changeset, field) do
    lowered_field = case Map.get(changeset.changes, field) do
      nil   -> nil
      field -> String.downcase(field)
    end
    put_change(changeset, field, lowered_field)
  end

  defp unique_pin() do
    pin = Enum.random(100000..999999) |> to_string
    case KratosApi.Repo.get_by(__MODULE__, pin: pin) do
      nil   -> pin
      _user -> unique_pin()
    end
  end

end
