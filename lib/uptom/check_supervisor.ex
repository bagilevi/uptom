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

  def add_or_update_site(site_id, url, frequency) do
    result = Supervisor.start_child(__MODULE__, worker(Uptom.SiteManager, [site_id, url, frequency], id: site_id))
    case result do
      {:ok, _} ->
        :ok
      {:error, {:already_started, pid}} ->
        Uptom.SiteManager.update_site(pid, site_id, url, frequency)
        :ok
    end
  end

  def remove_site(site_id) do
    Supervisor.terminate_child(__MODULE__, site_id)
    Supervisor.delete_child(__MODULE__, site_id)
  end

  def add_all_sites() do
    Uptom.CheckSupervisor.Queries.all_sites
    |> Enum.each(fn {id, url, frequency} -> add_or_update_site(id, url, frequency) end)
  end

  defmodule Queries do
    import Ecto.Query
    alias Uptom.Repo
    alias Uptom.Site

    def all_sites do
      Repo.all from p in Site,
        select: {p.id, p.url, p.frequency}
    end
  end
end
