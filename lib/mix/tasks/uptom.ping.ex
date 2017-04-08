defmodule Mix.Tasks.Uptom.Ping do
  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  @shortdoc "Ping a site and display results"

  def run([site_id]) do
    {site_id, _} = Integer.parse(site_id)

    ensure_started(Uptom.Repo, [])
    {:ok, _started} = Application.ensure_all_started(:httpotion)
    {:ok, _started} = Application.ensure_all_started(:gen_smtp)
    {:ok, _started} = Application.ensure_all_started(:swoosh)

    site = Uptom.Repo.one from s in Uptom.Site, where: s.id == ^site_id
    site = Uptom.SiteInfo.from_site_model(site)
    ping_result = Uptom.Pinger.ping(site.url)
    Mix.shell.info inspect(ping_result)
  end
end
