defmodule Mix.Tasks.Uptom.PingAndEmail do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  @shortdoc "Ping a site and send an email with the result"

  def run([site_id]) do
    {site_id, _} = Integer.parse(site_id)

    ensure_started(Uptom.Repo, [])
    {:ok, _started} = Application.ensure_all_started(:httpotion)
    {:ok, _started} = Application.ensure_all_started(:gen_smtp)
    {:ok, _started} = Application.ensure_all_started(:swoosh)

    site = Uptom.Repo.one from s in Uptom.Site, where: s.id == ^site_id
    site = Uptom.SiteInfo.from_site_model(site)
    ping_result = Uptom.Pinger.ping(site.url)
    Uptom.Alerter.alert(site, ping_result)
  end
end
