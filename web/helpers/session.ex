defmodule KratosApi.Session do
  alias KratosApi.{
    Repo, User
  }

  def authenticate(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))

    case password_and_confirmed(check_password(user, password), !!user.confirmed_email_at) do
      {:ok}             -> {:ok, user}
      {:error, message} -> {:error, message}
    end
  end

  defp password_and_confirmed(true, true), do: {:ok}
  defp password_and_confirmed(true, false), do: {:error, "Account has not been confirmed"}
  defp password_and_confirmed(false, _), do: {:error, "Invalid email or password"}

  defp check_password(nil, _password), do: false
  defp check_password(user, password), do: Comeonin.Bcrypt.checkpw(password, user.encrypted_password)

end
