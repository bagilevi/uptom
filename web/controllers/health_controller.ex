defmodule Uptom.HealthController do
  use Uptom.Web, :controller

  def index(conn, _params) do
    sites = Repo.all from s in Uptom.Site,
      where: s.enabled == true,
      where: fragment("((NOW() AT TIME ZONE 'utc') - interval '1 second' * frequency - INTERVAL '30 seconds') > last_checked_at")
    if Enum.count(sites) == 0 do
      conn
      |> text("OK\n")
    else
      conn
      |> put_status(500)
      |> text("FAIL\n#{Enum.count(sites)}\n")
    end
  end
end
