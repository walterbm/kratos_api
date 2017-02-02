defmodule KratosApi.EmailSignupController do
  use KratosApi.Web, :controller

  def create(conn, %{"email" => email}) do
    now = DateTime.utc_now() |> DateTime.to_string
    signup = %{"date" => now, "email" => email}
    ExAws.Dynamo.put_item("kratos-beta-signups", signup) |> ExAws.request!

    json allow_cors(conn), %{ok: true}
  end

  def options(conn, _params) do
    text allow_cors(conn), ""
  end

  defp allow_cors(conn) do
    conn
    |> put_resp_header("Access-Control-Allow-Origin", "*")
    |> put_resp_header("Access-Control-Allow-Headers", "Content-Type")
  end

end
