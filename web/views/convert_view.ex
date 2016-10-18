defmodule Stockman.ConvertView do
  use Stockman.Web, :view
  import Scrivener.HTML

  def allowed_currencies do
    Stockman.Convert.allowed_currencies
  end

  def selected_currency("base", convert), do: convert.base_currency || "EUR"
  def selected_currency("target", convert), do: convert.target_currency || "USD"

  def predicted_date(date, weeks) do
    Ecto.Date.to_string(date)
    |> Timex.parse!("%Y-%m-%d", :strftime)
    |> Timex.shift(weeks: weeks)
    |> Timex.format!("%d.%m.%Y", :strftime)
  end

  def predicted_rate(rate, rates) do
    old = rates |> Enum.min_by(fn(x) -> x.date end)

    Decimal.sub(current_rate(rates).rate, old.rate)
    |> Decimal.add(rate)
    |> Decimal.round(4)
  end

  def predicted_amount(amount, rate, rates) do
    predicted_rate(rate, rates)
    |> Decimal.mult(amount)
  end

  def profit_loss(amount, rate, rates) do
    current_amount = Decimal.mult(amount, current_rate(rates).rate)

    predicted_amount(amount, rate, rates)
    |> Decimal.sub(current_amount)
  end

  defp current_rate(rates) do
    rates |> Enum.max_by(fn(x) -> x.date end)
  end
end
