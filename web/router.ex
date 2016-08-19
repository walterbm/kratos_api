defmodule KratosApi.Router do
  use KratosApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KratosApi do
    pipe_through :api

    get "/", RootController, :index

    post "/districts", DistrictController, :post
    get "/districts/:state/:id", DistrictController, :show

    get "/representatives/:id/votes", RepresentativeController, :show
  end

end
