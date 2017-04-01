defmodule Uptom.SiteView do
  use Uptom.Web, :view

  def site_card_style(site) do
    case site.up do
      true -> 'site-up'
      false -> 'site-down'
      nil -> 'site-nostatus'
    end
  end
end
