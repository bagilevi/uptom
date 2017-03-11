defmodule Uptom.SiteChannel do
  use Phoenix.Channel

  def join("site:" <> _site_id, _message, socket) do
    {:ok, socket}
  end
end
