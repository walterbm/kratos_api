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
   get "/reset-password", ForgotPasswordController, :reset_password
   post "/reset-password", ForgotPasswordController, :new_password

 end

  scope "/api", KratosApi do
    pipe_through :api

    get "/", RootController, :index

    get "/districts/:state/:id", DistrictController, :show

    scope "/people" do
      get "/:id", PersonController, :show
      get "/:id/votes", VoteController, :index
    end

    get "/bills/:id", BillController, :show

    get "/tallies/:id", TallyController, :show

    post "/registrations", RegistrationController, :create

    post "/login", SessionController, :create
    post "/forgot-password", ForgotPasswordController, :forgot_password

    scope "/me" do
      get "/", CurrentUserController, :show
      post "/", CurrentUserController, :update
      post "/actions", CurrentUserController, :record_action
      resources "/votes", CurrentUserVoteController, except: [:edit, :new]
    end

    get "/feedback", FeedbackController, :index
    post "/feedback", FeedbackController, :create

    post "/signup", EmailSignupController, :create

  end

end
