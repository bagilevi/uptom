defmodule Uptom.Alerter do
  def alert(site, result) do
    Uptom.Email.alert(site.email, site.name, site.url, result)
    |> Uptom.Mailer.deliver!
  end
end
