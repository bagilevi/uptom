defmodule Uptom.PageController do
  use Uptom.Web, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: site_path(conn, :index))
    else
      render conn, "index.html"
    end
  end
end
