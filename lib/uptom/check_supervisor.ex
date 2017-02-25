defmodule Uptom.CheckSupervisor do
  @moduledoc """
    Supervises SiteManagers.
  """

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def init([]) do
    supervise([], strategy: :one_for_one)
  end

  def add_or_update_site(site_id, url, frequency) do
    case Supervisor.start_child(__MODULE__, worker(Uptom.SiteManager, [site_id, url, frequency])) do
      {:ok, _} ->
        :ok
      {:error, {:already_started, pid}} ->
        Uptom.SiteManager.update_site(pid, site_id, url, frequency)
        :ok
    end
  end
end
