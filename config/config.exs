# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

brand_name = "upTom"
from_email = "uptom@jkl.me"

# General application configuration
config :uptom,
  ecto_repos: [Uptom.Repo],
  brand_name: brand_name,
  email: from_email

# Configures the endpoint
config :uptom, Uptom.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "/gdYJrIvafwkJmlVp7ftG+F7uIe/94E8ViEcYaMOdVMhQsJf6/szmp2GJ3xcOPEC",
  render_errors: [view: Uptom.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Uptom.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Uptom.User,
  repo: Uptom.Repo,
  module: Uptom,
  logged_out_url: "/",
  email_from_name: brand_name,
  email_from_email: from_email,
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :confirmable, :registerable]

config :coherence, Uptom.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
