defmodule Uptom.Alerter do
  def alert(site, status) do
    Uptom.Email.alert(site.email, site.name, site.url, status) |> Uptom.Mailer.deliver!
  end
end
