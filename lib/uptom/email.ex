defmodule Uptom.Email do
  import Swoosh.Email

  def alert(email_address, url, status) do
    status_text = if status == :up, do: "UP", else: "DOWN"

    new
    |> to(email_address)
    |> from(Application.get_env(:uptom, :email))
    |> subject("#{status_text}")
    |> text_body("#{url} is #{status_text}!")
  end
end
