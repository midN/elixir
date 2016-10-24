defmodule Stockman.ConvertView do
  @moduledoc false

  use Stockman.Web, :view
  import Scrivener.HTML

  def allowed_currencies do
    Stockman.Convert.allowed_currencies
  end

  def selected_currency("base", convert), do: convert.base_currency || "EUR"
  def selected_currency("target", convert), do: convert.target_currency || "USD"

  def predicted_date(date, weeks) do
    edate = Ecto.Date.to_string(date)

    edate
    |> Timex.parse!("%Y-%m-%d", :strftime)
    |> Timex.shift(weeks: weeks)
    |> Timex.format!("%Y-%m-%d", :strftime)
  end

  def predicted_rate(rate, rates) do
    old = rates |> Enum.min_by(fn(x) -> x.date end)
    amount = Decimal.sub(current_rate(rates).rate, old.rate)

    amount
    |> Decimal.add(rate)
    |> rounded_3()
  end

  def predicted_amount(amount, rate, rates) do
    prate = predicted_rate(rate, rates)

    prate
    |> Decimal.mult(amount)
    |> rounded_3()
  end

  def profit_loss(amount, rate, rates) do
    current_amount = Decimal.mult(amount, current_rate(rates).rate)
    pamount = predicted_amount(amount, rate, rates)

    pamount
    |> Decimal.sub(current_amount)
    |> rounded_3()
  end

  def json_rates(amount, rates, weeks) do
    rates
    |> Enum.map(fn(x) -> %{
                    x: predicted_date(x.date, weeks),
                    y: predicted_amount(amount, x.rate, rates)
                  } end)
    |> Poison.encode!()
    |> raw
  end

  def top_three_rates(rates) do
    rates
    |> Enum.sort(fn(x, y) -> x.rate > y.rate end)
    |> Enum.slice(0..2)
  end

  def rounded_3(amount) do
    string_amount = Decimal.to_string(amount)

    case string_amount |> String.contains?(".") do
      true ->
        try do
          rounded_amount = Decimal.round(amount, 3)
          rounded_amount |> Decimal.to_integer |> Decimal.new
        rescue
          _ -> Decimal.round(amount, 3)
        end
      false ->
        amount
    end
  end

  defp current_rate(rates) do
    rates |> Enum.max_by(fn(x) -> x.date end)
  end
end
