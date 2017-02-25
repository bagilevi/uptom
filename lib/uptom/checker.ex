defmodule Uptom.Checker do
  @moduledoc """
    Executes a single check to the site and any associated behaviours,
    like saving the result, sending up/down notifications.
  """
  def check(site_id, url) do
    started_at = :calendar.universal_time()

    {outcome, details} = result = Uptom.Pinger.ping(url)

    params = %{ site_id:     site_id,
                started_at:  started_at,
                success:     outcome == :up,
                status_code: details[:status_code],
                message:     details[:message] }

    changeset = Uptom.SitePing.changeset(%Uptom.SitePing{}, params)
    Uptom.Repo.insert!(changeset)

    result
  end
end
