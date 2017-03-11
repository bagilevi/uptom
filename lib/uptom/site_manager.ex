defmodule Uptom.SiteManager do
  @moduledoc """
    Long-running process that schedules checks for a single site.
  """

  use GenServer

  def start_link(site_id) do
    {:ok, pid} = GenServer.start_link(
      __MODULE__,
      [ site_id: site_id,
        site: Uptom.SiteQuery.by_id(site_id),
        timer: nil,
        status: nil ],
      name: {:global, {:site_manager, site_id}}
    )
    {:ok, pid}
  end

  def update_site(pid, site) do
    GenServer.cast(pid, {:update_site, site})
  end

  def init(state) do
    state = schedule_next_run(state)
    {:ok, state}
  end

  def handle_info(:work, state) do
    state = schedule_next_run(state)
    site_manager_pid = self()

    pid = spawn(fn ->
      result = Uptom.Checker.check(state[:site].id, state[:site].url)
      update_result(result, site_manager_pid)
    end)
    Process.monitor(pid)

    {:noreply, state}
  end

  def handle_info({:DOWN, _, _, _, info} = _message, state) do
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

  def handle_cast({:update_site, site}, state) do
    if site.id == state[:site_id] do
      IO.puts "SiteManager[#{state[:site_id]}] updating site:"
      state = state |> Keyword.put(:site, site) |> schedule_next_run
      {:noreply, state}
    else
      IO.puts "site_id doesn't match: #{site.id} #{state[:site_id]}"
      {:noreply, state}
    end
  end

  defp schedule_next_run(state) do
    if state[:timer], do: Process.cancel_timer(state[:timer])
    timer = Process.send_after(self(), :work, state[:site].frequency * 1000)
    Keyword.put(state, :timer, timer)
  end

  def update_result(result, site_manager_pid) do
    GenServer.cast(site_manager_pid, {:result, result})
  end

  def send_alert(state, status) do
    Uptom.Alerter.alert(
      state[:site],
      status
    )
  end
end
