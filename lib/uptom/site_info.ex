defmodule Uptom.SiteInfo do
  @enforce_keys [:id, :url, :name, :frequency, :email, :last_checked_at]
  defstruct [:id, :url, :name, :frequency, :email, :last_checked_at]

  def from_site_model(site_model) do
    site = Uptom.Repo.preload(site_model, :user)
    %Uptom.SiteInfo{
      id:              site.id,
      name:            site.name,
      url:             site.url,
      frequency:       site.frequency,
      last_checked_at: to_unix_time(site.last_checked_at),
      email:           site.user.email
    }
  end

  def get(site_id) do
    from_site_model Uptom.SiteQuery.by_id(site_id)
  end

  defp to_unix_time(%Ecto.DateTime{} = datetime) do
    datetime
    |> Ecto.DateTime.to_erl
    |> :calendar.datetime_to_gregorian_seconds
    |> Kernel.-(62167219200)
  end

  defp to_unix_time(nil), do: nil
end
