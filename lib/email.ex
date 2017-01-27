defmodule Email do
  use Bamboo.Phoenix, view: KratosApi.EmailView

  @support "support@getkratos.com"
  @url Application.get_env(:kratos_api, :url)

  def forgot_password_email(email_address, reset_token) do
    base_email()
    |> to(email_address)
    |> subject("Kratos Account Recovery")
    |> text_body("Forgot Your Kratos Password? Copy this url to reset: #{@url <> "/reset-password?reset_token="}#{reset_token}")
    |> render("forgot_password.html", reset_token: reset_token, url: @url <> "/reset-password?reset_token=")
  end

  defp base_email do
    new_email()
    |> from(@support)
    |> put_text_layout({KratosApi.LayoutView, "email.text"})
    |> put_html_layout({KratosApi.LayoutView, "email.html"})
  end

end
