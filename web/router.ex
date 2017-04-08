defmodule Uptom.Router do
  use Uptom.Web, :router
  use Coherence.Router
  use Plug.ErrorHandler

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

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    conn =
      conn
      |> Plug.Conn.fetch_cookies()
      |> Plug.Conn.fetch_query_params()

    conn_data = %{
      "request" => %{
        "cookies" => conn.req_cookies,
        "url" => "#{conn.scheme}://#{conn.host}:#{conn.port}#{conn.request_path}",
        "user_ip" => (conn.remote_ip |> Tuple.to_list() |> Enum.join(".")),
        "headers" => Enum.into(conn.req_headers, %{}),
        "params" => conn.params,
        "method" => conn.method,
      }
    }

    Rollbax.report(kind, reason, stacktrace, %{}, conn_data)
  end
end
