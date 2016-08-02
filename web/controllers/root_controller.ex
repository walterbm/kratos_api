defmodule KratosApi.RootController do
  use KratosApi.Web, :controller

  def index(conn, _params) do
    json conn, "Welcome to the Kratos API!"
  end
  
end
