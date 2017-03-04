defmodule Uptom.SiteInfo do
  @enforce_keys [:id, :url, :frequency, :email]
  defstruct [:id, :url, :frequency, :email]

  def from_site_model(site_model) do
    IO.inspect site_model
    site = Uptom.Repo.preload(site_model, :user)
    %Uptom.SiteInfo{
      id:        site.id,
      url:       site.url,
      frequency: site.frequency,
      email:     site.user.email
    }
  end
end
