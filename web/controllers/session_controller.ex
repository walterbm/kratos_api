defmodule KratosApi.SessionController do
  use KratosApi.Web, :controller

  alias KratosApi.Session

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    case Session.authenticate(session_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =  Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt)
      {:error, :unconfirmed} ->
        conn
        |> put_status(:forbidden)
        |> render("unconfirmed.json")
      {:error, message} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", message: message)
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render("forbidden.json", error: "Not Authenticated")
  end

end
