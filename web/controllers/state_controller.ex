defmodule KratosApi.StateController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    Repo,
    Person,
    StateImage
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def show(conn, %{ "state" => state }) do
    query = from p in Person,
      where: p.is_current == true,
      where: p.current_state == ^String.upcase(state),
      distinct: p.current_district,
      where: not is_nil(p.current_district),
      select: p.current_district

    districts = Repo.all(query)

    json conn, %{ districts: districts }
  end

  def image(conn, %{ "state" => state }) do
     case Repo.get(StateImage, String.upcase(state)) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(KratosApi.ErrorView, "404.json")
      state ->
        json conn, %{ url: state.image_url }
    end
  end

end
