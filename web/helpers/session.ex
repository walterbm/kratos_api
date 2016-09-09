defmodule KratosApi.Session do
  alias KratosApi.{Repo, User}

  def authenticate(%{"phone" => phone, "password" => password}) do
    user = Repo.get_by(User, phone: phone)

    case check_password(user, password) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
    end
  end

end
