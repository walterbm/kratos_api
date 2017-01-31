defmodule KratosApi.Session do
  alias KratosApi.{Repo, User}

  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))

    if check_password(user, password) do
      {:ok, user}
    else
      :error
    end
  end

  defp check_password(nil, _password), do: false
  defp check_password(user, password), do: Comeonin.Bcrypt.checkpw(password, user.encrypted_password)

end
