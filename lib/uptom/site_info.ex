defmodule Uptom.SiteInfo do
  @enforce_keys [:id, :url, :name, :frequency, :email]
  defstruct [:id, :url, :name, :frequency, :email]

  def from_site_model(site_model) do
    site = Uptom.Repo.preload(site_model, :user)
    %Uptom.SiteInfo{
      id:        site.id,
      name:      site.name,
      url:       site.url,
      frequency: site.frequency,
      email:     site.user.email
    }
  end

  def get(site_id) do
    from_site_model Uptom.SiteQuery.by_id(site_id)
  end
end
