defmodule KratosApi.SessionController do
  use KratosApi.Web, :controller

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case KratosApi.Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)

      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: message)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(KratosApi.SessionView, "forbidden.json", error: "Not Authenticated")
  end

end
