defmodule KratosApi.BasicAuth do

  def init(_) do

  end

  def call(conn, _) do
    header_content = Plug.Conn.get_req_header(conn, "authorization")
    respond(conn, header_content)
  end

  defp respond(conn, ["Basic " <> encoded_string]) do
    [ username, password ] = encoded_string
    |> Base.decode64!
    |> String.split(":")

    respond(conn, username, password)
  end

  defp respond(conn, _) do
    send_unauthorized_response(conn)
  end

  defp respond(conn, username, password) do
    if { username, password } == { get(:username), get(:password) } do
      conn
    else
      send_unauthorized_response(conn)
    end
  end

  defp send_unauthorized_response(conn) do
    conn
    |> Plug.Conn.send_resp(401, "401 Unauthorized")
    |> Plug.Conn.halt
  end

  defp get(field), do: Application.get_env(:kratos_api, :basic_auth) |> Map.get(field)
end
