defmodule Uptom.CheckSupervisor do
  @moduledoc """
    Supervises SiteManagers.
  """

  use Supervisor

  def start_link do
    {:ok, pid} = Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
    add_all_sites
    {:ok, pid}
  end

  def init([]) do
    supervise([], strategy: :one_for_one)
  end

  def add_or_update_site(site) do
    site = Uptom.SiteInfo.from_site_model(site)
    result = Supervisor.start_child(__MODULE__, worker(Uptom.SiteManager, [site.id], id: site.id))
    case result do
      {:ok, _} ->
        :ok
      {:error, {:already_started, pid}} ->
        Uptom.SiteManager.update_site(pid, site)
        :ok
    end
  end

  def remove_site(site_id) do
    Supervisor.terminate_child(__MODULE__, site_id)
    Supervisor.delete_child(__MODULE__, site_id)
  end

  def add_all_sites() do
    Uptom.CheckSupervisor.Queries.all_sites
    |> Enum.each(fn site -> add_or_update_site(site) end)
  end

  defmodule Queries do
    import Ecto.Query
    alias Uptom.Repo
    alias Uptom.Site

    def all_sites do
      Repo.all from s in Site, preload: :user
    end
  end
end
