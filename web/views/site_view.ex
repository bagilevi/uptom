defmodule Uptom.SiteView do
  use Uptom.Web, :view

  def site_color(site) do
    case site.up do
      true -> 'green darken-3'
      false -> 'red darken-3'
      nil -> 'grey darken-1'
    end
  end
end
