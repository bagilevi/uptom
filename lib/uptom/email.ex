defmodule Uptom.Email do
  use Phoenix.Swoosh, view: Uptom.EmailView, layout: {Uptom.LayoutView, :email}

  import Swoosh.Email

  def alert(email_address, name, url, result) do
    {status, details} = result
    status_text = if status == :up, do: "UP", else: "DOWN"
    details_text = cond do
      details[:status_code] -> "Server returned status code #{details[:status_code]}"
      details[:message] == "req_timedout" -> "Request timed out"
      details[:message] == "conn_failed" -> "Connection failed"
      details[:message] == "econnrefused" -> "Connection refused"
      details[:message] -> "Failed with code: #{details[:message]}"
      true -> nil
    end

    new
    |> to(email_address)
    |> from({Application.get_env(:uptom, :brand_name), Application.get_env(:uptom, :email)})
    |> subject("#{name} is #{status_text}")
    |> render_body(:alert, %{
                              site_name:    name,
                              site_url:     url,
                              status_text:  status_text,
                              details_text: details_text,
                              root_url:     root_url
                            })
  end

  defp root_url, do: Application.get_env(:uptom, Uptom.Endpoint)[:root_url]
end
