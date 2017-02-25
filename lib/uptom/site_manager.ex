defmodule Uptom.SiteManager do
  @moduledoc """
    Long-running process that schedules checks for a single site.
  """

  use GenServer

  def start_link(site_id, url, frequency) do
    GenServer.start_link(
      __MODULE__,
      [ site_id: site_id,
        url: url,
        frequency: frequency,
        status: nil ],
      name: {:global, {:site_manager, site_id}}
    )
  end

  def update_site(pid, site_id, url, frequency) do
    GenServer.cast(pid, {:update_site, site_id, url, frequency})
  end

  def init(state) do
    schedule_work(state[:frequency])
    {:ok, state}
  end

  def handle_info(:work, state) do
    schedule_work(state[:frequency])
    site_manager_pid = self()

    pid = spawn(fn ->
      result = Uptom.Checker.check(state[:site_id], state[:url])
      update_result(result, site_manager_pid)
    end)
    Process.monitor(pid)

    {:noreply, state}
  end

  def handle_info({:DOWN, _, _, _, info} = message, state) do
    case info do
      :normal -> nil
      _ ->
        # IO.inspect message
        update_result({:error, [message: "internal: checker failed"]}, self())
    end
    {:noreply, state}
  end

  def handle_cast({:result, result}, state) do
    new_state =
      case result do
        {:up, _} ->
          if state[:status] === :down, do: send_alert(state, :up)
          Keyword.put(state, :status, :up)
        {:down, _} ->
          if state[:status] === :up, do: send_alert(state, :down)
          Keyword.put(state, :status, :down)
        _ -> state
      end

    {:noreply, new_state}
  end

  def handle_cast({:update_site, new_site_id, new_url, new_frequency}, state) do
    if new_site_id == state[:site_id] do
      {:noreply, Keyword.merge(state, [url: new_url, frequency: new_frequency])}
    else
      IO.puts "site_id doesn't match: #{new_site_id} #{state[:site_id]}"
      {:noreply, state}
    end
  end

  defp schedule_work(frequency) do
    Process.send_after(self(), :work, frequency * 1000)
  end

  def update_result(result, site_manager_pid) do
    GenServer.cast(site_manager_pid, {:result, result})
  end

  def send_alert(state, status) do
    Uptom.Alerter.alert(
      state[:site_id],
      status
    )
  end
end
