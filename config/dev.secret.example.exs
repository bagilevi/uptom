use Mix.Config

config :uptom, Uptom.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "CHANGEME",
  domain: "CHANGEME"

config :coherence, Uptom.Coherence.Mailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: "CHANGEME",
  domain: "CHANGEME"
