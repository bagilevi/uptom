defmodule Uptom.CommonHelpers do
  use Phoenix.HTML

  def back_button(href, label \\ "Back") do
    content_tag(:a, href: href, class: "btn btn-flat") do
      html_escape([back_icon, label])
    end
  end

  def back_icon do
    content_tag(:i, "fast_rewind", class: "material-icons left")
  end

  def centered_card([do: block]) do
    div_tag "row" do
      div_tag "centered-form" do
        div_tag "card grey lighten-4" do
          div_tag "card-content" do
            block
          end
        end
      end
    end
  end

  def centered_card(title, [do: block]) do
    centered_card() do
      html_escape([
        content_tag(:span, title, class: "card-title"),
        block
      ])
    end
  end

  def div_tag(class, [do: block]) do
    content_tag(:div, block, class: class)
  end
end
