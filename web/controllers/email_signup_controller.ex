defmodule KratosApi.EmailSignupController do
  use KratosApi.Web, :controller

  def create(conn, %{"email" => email}) do
    now = DateTime.utc_now() |> DateTime.to_string
    signup = %{"date" => now, "email" => email}
    ExAws.Dynamo.put_item("kratos-beta-signups", signup) |> ExAws.request!

    json conn, %{ok: true}
  end

end
