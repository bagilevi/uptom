defmodule Uptom.SiteChannel do
  use Phoenix.Channel

  def join("site:" <> site_id, message, socket) do
    {:ok, socket}
  end
end
