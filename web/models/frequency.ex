defmodule Uptom.Frequency do
  def allowed_values do
    [1,2,3,5,10,15,20,30,45,60]
    |> Enum.map fn x -> x * 60 end
  end

  def humanize_every(seconds) do
    "every #{humanize(seconds, omit_ones: true)}"
  end

  def humanize(seconds, opts \\ []) do
    humanize(seconds, [60, 60], ["second", "minute", "hour"], opts)
  end

  def humanize(amount, divisors, units, opts) do
    if divisors == [] || amount < hd(divisors) do
      displayed_amount =
        if amount == 1 && opts[:omit_ones] do
          ""
        else
          "#{round(amount)} "
        end
      "#{displayed_amount}#{hd(units)}#{if amount > 1, do: "s"}"
    else
      humanize(amount / hd(divisors), tl(divisors), tl(units), opts)
    end
  end
end
