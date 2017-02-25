use Mix.Config

config :uptom, Uptom.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.mailgun.org",
  port: 25,
  username: "TODO",
  password: "TODO",
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1
