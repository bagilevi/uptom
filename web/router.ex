defmodule Uptom.Router do
  use Uptom.Web, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, db_model: Uptom.User
    # plug :current_user
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, db_model: Uptom.User, protected: true
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end

  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", Uptom do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/health", HealthController, :index

    get "/login", SessionController, :new
    post "/session", SessionController, :create
    get "/logout", SessionController, :delete
    get "/join", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/passwords/new", PasswordController, :new
    post "/passwords", PasswordController, :reset
  end

  # Registered User Zone
  scope "/", Uptom do
    pipe_through :protected

    resources "/sites", SiteController
  end


  # Other scopes may use custom stacks.
  # scope "/api", Uptom do
  #   pipe_through :api
  # end
end
