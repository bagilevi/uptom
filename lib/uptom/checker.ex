defmodule Uptom.Checker do
  def check(site_id, url) do
    started_at = :calendar.universal_time()

    {result, details} = Uptom.Pinger.ping(url)

    params = %{ site_id:     site_id,
                started_at:  started_at,
                success:     result == :ok,
                status_code: details[:status_code],
                message:     details[:message] }

    changeset = Uptom.SitePing.changeset(%Uptom.SitePing{}, params)
    Uptom.Repo.insert!(changeset)
  end
end
