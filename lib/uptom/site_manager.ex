defmodule Uptom.SiteManager do
  @moduledoc """
    Long-running process that schedules checks for a single site.
  """

  use GenServer

  def start_link(site_id, url, frequency) do
    GenServer.start_link(
      __MODULE__,
      {site_id, url, frequency},
      name: {:global, {:site_manager, site_id}}
    )
  end

  def update_site(pid, site_id, url, frequency) do
    GenServer.cast(pid, {:update_site, site_id, url, frequency})
  end

  def init({site_id, url, frequency}) do
    schedule_work(frequency)
    {:ok, {site_id, url, frequency}}
  end

  def handle_info(:work, {site_id, url, frequency}) do
    schedule_work(frequency)

    pid = spawn(fn ->
      result = Uptom.Checker.check(site_id, url)
      update_result(result)
    end)
    Process.monitor(pid)

    {:noreply, {site_id, url, frequency}}
  end

  def handle_info({:DOWN, _, _, _, info} = message, state) do
    case info do
      :normal -> nil
      _ ->
        # IO.inspect message
        update_result({:error, [message: "internal: checker failed"]})
    end
    {:noreply, state}
  end

  def handle_cast({:update_site, new_site_id, new_url, new_frequency}, {site_id, url, frequency}) do
    if ^new_site_id = site_id do
      {:noreply, {site_id, new_url, new_frequency}}
    else
      {:noreply, {site_id, url, frequency}}
    end
  end

  defp schedule_work(frequency) do
    Process.send_after(self(), :work, frequency * 1000)
  end

  def update_result(result) do
    IO.inspect result
  end
end
