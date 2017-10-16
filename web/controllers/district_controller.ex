defmodule KratosApi.DistrictController do
  use KratosApi.Web, :controller

  alias KratosApi.{
    ErrorView,
  }

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  @find_district Application.get_env(:kratos_api, :remote_district_lookup)

  def find(conn, %{"query" => query }) do
    case @find_district.by_query(query) do
      {:ok, {state, district}} ->
         json conn, %{ state: state, district: district }
      {:error, _}    ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "bad_address.json")
    end
  end

  def show(conn, params) do
    query = from p in KratosApi.Person,
      where: p.current_state == ^String.upcase(params["state"]),
      where: p.current_district == ^params["id"] or p.current_office ==  "Senate",
      preload: [:terms]

    conn |> Guardian.Plug.current_resource |> KratosApi.UserAnalytics.mark_online

    {representatives, kerosene} = query |> KratosApi.Repo.paginate(params)

    render(conn, "representatives.json", representatives: representatives, kerosene: kerosene)
  end

end
