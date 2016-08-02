defmodule KratosApi.PageController do
  use KratosApi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
