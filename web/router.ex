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
      get "/", MeController, :show
      post "/", MeController, :update
      post "/actions", MeController, :create_action
      get "/bills", MeController, :bills
      post "/bills", MeController, :track_bill
      get "/bills/:id", MeController, :bill
      delete "/bills/:id", MeController, :untrack_bill
      get "/subjects", MeController, :subjects
      post "/subjects", MeController, :track_subject
      delete "/subjects/:id", MeController, :untrack_subject
      get "/votes", MeController, :votes
      post "/votes", MeController, :create_vote
      get "/votes/:id", MeController, :vote
      patch "/votes/:id", MeController, :update_vote
      delete "/votes/:id", MeController, :delete_vote
    end
    post "/login", SessionController, :create

    post "/registrations", RegistrationController, :create

    post "/forgot-password", RegistrationController, :forgot_password

    post "/confirmation", RegistrationController, :confirm_post
    post "/confirmation/request", RegistrationController, :confirm_request

    get "/feedback", FeedbackController, :index
    post "/feedback", FeedbackController, :create

    post "/signup", EmailSignupController, :create
    options  "/signup", EmailSignupController, :options

    get "/jobs", JobController, :run

    scope "/analytics" do
      post "/track/:resource_type/:resource_id", AnalyticsController, :track
    end

  end

end
