defmodule Uptom.SiteQuery do
  import Ecto.Query
  alias Uptom.{Repo, Site}

  def by_id(id) do
    Repo.one!(from s in Site, where: s.id == ^id)
  end
end
