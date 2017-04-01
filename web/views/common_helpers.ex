defmodule Uptom.CommonHelpers do
  use Phoenix.HTML
  import Uptom.ErrorHelpers


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

  def mat_text_input(form, field, label_text, opts \\ []) do
    div_tag("row") do
      div_tag("input-field col s12") do
        html_escape([
          text_input(form, field, class: "form_control #{if form.errors[field], do: "invalid"}"),
          label(form, field, label_text, class: "control-label"),
          error_tag(form, field)
        ])
      end
    end
  end
end
