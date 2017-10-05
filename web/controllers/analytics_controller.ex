defmodule KratosApi.AnalyticsController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController

  def track(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    params = Map.merge(params, %{"user_id" => user.id})
    case KratosApi.Analytics.track_resource(params) do
      {:ok, _record}   -> json conn, %{"tracked": true}
      {:error, _error} -> json conn, %{"tracked": false}
    end
  end

end
