defmodule Uptom.Email do
  use Bamboo.Phoenix, view: Uptom.EmailView

  def alert(email_address) do
    new_email
    |> to(email_address)
    |> from("me@example.com")
    |> subject("DOWN")
    |> text_body("Your site is DOWN!")
  end
end
