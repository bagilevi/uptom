defmodule Uptom.PageController do
  use Uptom.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
