defmodule Uptom.SmartPinger do
  @moduledoc """
    Checks if the website is up, but making sure that network errors are not
    regarded as a failure of the target site.

    On connection errors, it ping Google to see if there is a network
    problem, and re-pings the target site. If the second ping is successful,
    returns success. If there is a network problem, returns a check error,
    which means we could not determine that whether the target site was up or
    not.
  """

  require Logger
  alias Uptom.Pinger

  def ping(url, opts \\ [timeout: 5_000]) do
    result = Pinger.ping(url, opts)
    Logger.debug "SmartPinger - #{url} => #{inspect(result)}"
    if connection_error?(result) do
      ping_with_network_check(url, opts)
    else
      result
    end
  end

  defp connection_error?({outcome, details} = result) do
    outcome == :down && details[:status_code] == nil
  end

  defp ping_with_network_check(url, opts) do
    target_task = Task.async(fn -> Pinger.ping(url) end)
    netcheck_url = "http://google.com"
    netcheck_task = Task.async(fn -> Pinger.ping(netcheck_url) end)

    target_result = Task.await(target_task, opts[:timeout])
    Logger.debug "SmartPinger - #{url} => #{inspect(target_result)}"
    if connection_error?(target_result) do
      netcheck_result = Task.await(netcheck_task, opts[:timeout])
      Logger.debug "SmartPinger - #{netcheck_url} => #{inspect(netcheck_result)}"
      if connection_error?(netcheck_result) do
        {:error, [message: "network issue"]}
      else
        target_result
      end
    else
      target_result
    end
  end
end
