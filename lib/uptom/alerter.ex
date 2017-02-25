defmodule Uptom.Alerter do
  import Ecto.Query
  alias Uptom.Repo
  alias Uptom.Site

  def alert(site_id, status) do
    {url, email} =
      Repo.one! from s in Site,
        join: u in assoc(s, :user),
        where: s.id == ^site_id,
        select: {s.url, u.email}

    Uptom.Email.alert(email, url, status) |> Uptom.Mailer.deliver_now
  end
end
