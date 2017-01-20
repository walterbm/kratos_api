defmodule KratosApi.Router do
  use KratosApi.Web, :router

  require Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", KratosApi do
   pipe_through :browser

   get "/doc", DocumentationController, :index
 end

  scope "/api", KratosApi do
    pipe_through :api

    get "/", RootController, :index

    get "/districts/:state/:id", DistrictController, :show

    get "/people/:id", PersonController, :show
    get "/people/:id/votes", VoteController, :index

    get "/bills/:id", BillController, :show

    get "/tallies/:id", TallyController, :show

    post "/registrations", RegistrationController, :create

    post "/login", SessionController, :create

    scope "/me" do
      get "/", CurrentUserController, :show
      post "/", CurrentUserController, :update
      post "/actions", CurrentUserController, :record_action
      resources "/votes", CurrentUserVoteController, except: [:edit, :new]
    end

  end

end
