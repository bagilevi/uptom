defmodule Uptom.Email do
  use Bamboo.Phoenix, view: Uptom.EmailView

  def alert(email_address, url, status) do
    status_text = if status == :up, do: "UP", else: "DOWN"

    new_email
    |> to(email_address)
    |> from("me@example.com")
    |> subject("#{status_text}")
    |> text_body("#{url} is #{status_text}!")
  end
end
