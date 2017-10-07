defmodule KratosApi.AnalyticsController do
  use KratosApi.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: KratosApi.SessionController
  plug :scrub_params, "user_action" when action in [:track_user_action]

  def track(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    params = Map.merge(params, %{"user_id" => user.id})
    case KratosApi.Analytics.track_resource(params) do
      {:ok, _record}   -> json conn, %{"tracked": true}
      {:error, _error} -> json conn, %{"tracked": false}
    end
  end

  def track_user_action(conn, %{"user_action" => user_action }) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.merge(user_action, %{"user_id" => user.id})
    case KratosApi.Analytics.track_user_action(params) do
      {:ok, _record}   -> json conn, %{"tracked": true}
      {:error, _error} -> json conn, %{"tracked": false}
    end
  end


end
