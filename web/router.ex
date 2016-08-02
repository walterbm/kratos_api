defmodule KratosApi.Router do
  use KratosApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KratosApi do
    pipe_through :api

    get "/", RootController, :index
  end

end
