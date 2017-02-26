# Uptom

Website uptime monitoring application written in Elixir/Phoenix.

It checks the configured URLs periodically, sending an email when the
website goes down or up.

## Installation

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Copy `config/dev.secret.example.exs` to `config/dev.secret.exs` and add your SMTP details
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check the Phoenix deployment guides](http://www.phoenixframework.org/docs/deployment).

## License

MIT, see the LICENSE file.

## Contributing

Contributions are welcome, please submit an issue, pull request or
comment on the code. I am learning Elixir and Phoenix, any tips will be
most welcome!
