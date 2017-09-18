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
    get "/reset-password", RegistrationController, :reset_password
    get "/confirmation", RegistrationController, :confirm
    post "/reset-password", RegistrationController, :new_password
  end

  scope "/cms", KratosApi do
    pipe_through :browser
    get "/", CMSController, :index
    get "/state/image", CMSController, :state_image_index
    post "/state/image", CMSController, :state_image_create
    delete "/state/image/:state", CMSController, :state_image_delete
  end

  scope "/api", KratosApi do
    pipe_through :api

    get "/", RootController, :index

    scope "/congress" do
      get "/recess", CongressController, :recess
      get "/trending", CongressController, :trending
      get "/:chamber/floor", CongressController, :floor
    end

    scope "/districts" do
      get "/:state/:id", DistrictController, :show
    end

    scope "/states" do
      get "/:state", StateController, :show
      get "/:state/image", StateController, :image
    end

    scope "/people" do
      get "/:id", PersonController, :show
      get "/:id/votes", VoteController, :index
      get "/:id/bills", BillController, :sponsored
    end

    scope "/bills" do
      get "/", BillController, :index
      get "/:id", BillController, :show
    end

    scope "/tallies" do
      get "/:id", TallyController, :show
    end

    scope "/subjects" do
      get "/", SubjectController, :index
    end

    scope "/me" do
      get "/", CurrentUserController, :show
      post "/", CurrentUserController, :update
      post "/actions", CurrentUserController, :record_action
      resources "/votes", CurrentUserVoteController, except: [:edit, :new]
      resources "/bills", CurrentUserBillController, except: [:edit, :update, :new]
      resources "/subjects", CurrentUserSubjectController, except: [:edit, :update, :new, :show]
    end
    post "/login", SessionController, :create

    post "/registrations", RegistrationController, :create

    post "/forgot-password", RegistrationController, :forgot_password

    post "/confirmation/request", RegistrationController, :confirmation_request

    get "/feedback", FeedbackController, :index
    post "/feedback", FeedbackController, :create

    post "/signup", EmailSignupController, :create
    options  "/signup", EmailSignupController, :options

    get "/jobs", JobController, :run

  end

end
