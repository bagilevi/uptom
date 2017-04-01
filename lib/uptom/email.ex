defmodule Uptom.Email do
  use Phoenix.Swoosh, view: Uptom.EmailView, layout: {Uptom.LayoutView, :email}

  import Swoosh.Email

  def alert(email_address, name, url, status) do
    status_text = if status == :up, do: "UP", else: "DOWN"

    new
    |> to(email_address)
    |> from({Application.get_env(:uptom, :brand_name), Application.get_env(:uptom, :email)})
    |> subject("#{name} is #{status_text}")
    |> text_body("#{name} (#{url}) is #{status_text}\n\nYours truly,\nupTom\n#{root_url}")
    |> render_body("alert.html", %{site_name: name, site_url: url, status_text: status_text, root_url: root_url})
  end

  defp root_url, do: Application.get_env(:uptom, Uptom.Endpoint)[:root_url]
end
