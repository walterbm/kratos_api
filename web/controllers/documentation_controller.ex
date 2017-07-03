defmodule KratosApi.DocumentationController do
  use KratosApi.Web, :controller

  plug KratosApi.BasicAuth

  def index(conn, _params) do
    conn
    |> put_layout(false)
    |> render("index.html")
  end
end
