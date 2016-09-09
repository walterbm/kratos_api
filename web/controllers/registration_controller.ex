defmodule KratosApi.RegistrationController do
  use KratosApi.Web, :controller

  alias KratosApi.{Repo, User}

  plug :scrub_params, "user" when action in [:create]
  
  @geocodio Application.get_env(:kratos_api, :geocodio)

  def create(conn, %{"user" => user_params}) do
    new_user = Map.merge(user_params, get_congressional_district(user_params))

    changeset = User.changeset(%User{}, new_user)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render(KratosApi.SessionView, "show.json", jwt: jwt, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(KratosApi.RegistrationView, "error.json", changeset: changeset)
    end
  end

  defp get_congressional_district(params) do
    %{"address" => address, "city" => city, "state" => state, "zip" => zip} = params
    q = "#{address} #{city} #{state} #{zip}"

    geocodio_response = HTTPotion.get(@geocodio[:api_url], query: %{q: q, api_key: @geocodio[:api_key], fields: "cd"}).body
      |> Poison.decode!
    %{"district" => List.first(geocodio_response["results"])["fields"]["congressional_district"]["district_number"]}
  end

end
