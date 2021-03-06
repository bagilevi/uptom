defmodule Uptom.Checker do
  @moduledoc """
    Executes a single check to the site and any associated behaviours,
    like saving the result, sending up/down notifications.
  """
  import Ecto.Query

  def check(site_id, url) do
    started_at = :calendar.universal_time()

    {outcome, _} = result = Uptom.SmartPinger.ping(url)

    unless outcome == :error do
      push_update_to_clients(site_id, started_at, result)
      insert_ping(site_id, started_at, result)
      update_site_status(site_id, started_at, result)
    end

    result
  end

  defp insert_ping(site_id, started_at, {outcome, details}) do
    params = %{ site_id:     site_id,
                started_at:  started_at,
                success:     outcome == :up,
                status_code: details[:status_code],
                message:     details[:message] }

    changeset = Uptom.SitePing.changeset(%Uptom.SitePing{}, params)
    Uptom.Repo.insert!(changeset)
  end

  defp update_site_status(site_id, started_at, {outcome, _details}) do
    up = (outcome == :up)
    from(s in Uptom.Site, where: s.id == ^site_id)
      |> Uptom.Repo.update_all(set: [ up: up,
                                      last_checked_at: started_at ])
  end

  defp push_update_to_clients(site_id, _started_at, {outcome, _details}) do
    Uptom.Endpoint.broadcast!("site:#{site_id}", "ping_result", %{outcome: outcome})
  end
end
