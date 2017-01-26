defmodule KratosApi.ForgotPasswordController do
  use KratosApi.Web, :controller

  import Joken

  def forgot_password(conn, %{"email" => email}) do

    reset_token =
      %{email: email} |> token |> with_signer(hs256(Application.get_env(:joken, :secret_key)))

  end

  def reset_password_form(conn, params) do

  end

  def set_new_password(conn, %{"token" => token, "password" => password}) do

  end

end
