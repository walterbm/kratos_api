defmodule KratosApi.Router do
  use KratosApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", KratosApi do
   pipe_through :browser

   get "/doc", DocumentationController, :index
 end

  scope "/api", KratosApi do
    pipe_through :api

    get "/", RootController, :index

    post "/districts", DistrictController, :post
    get "/districts/:state/:id", DistrictController, :show

    get "/representatives/:id/votes", RepresentativeController, :show

    get "/bills/:id", BillController, :show
  end

end
