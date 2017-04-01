defmodule Uptom.Email do
  import Swoosh.Email

  def alert(email_address, name, url, status) do
    status_text = if status == :up, do: "UP", else: "DOWN"

    new
    |> to(email_address)
    |> from(Application.get_env(:uptom, :email))
    |> subject("#{name} is #{status_text}")
    |> text_body("#{name} (#{url}) is #{status_text}\n\nSent by upTom - #{root_url}")
  end

  defp root_url, do: Application.get_env(:uptom, Uptom.Endpoint)[:root_url]
end
