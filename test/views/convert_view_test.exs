defmodule Stockman.ConvertViewTest do
  use Stockman.ConnCase, async: true

  alias Stockman.ConvertView

  @moduletag :convert_view

  describe "ConvertView.allowed_currencies" do
    test "gets allowed currencies from Convert" do
      assert "EUR" in ConvertView.allowed_currencies
      refute "BLA" in ConvertView.allowed_currencies
    end
  end

  describe "ConvertView.selected_currency/2" do
    test "gets base currency from convert" do
      convert = %{base_currency: "wow"}
      assert ConvertView.selected_currency("base", convert) == "wow"
    end

    test "gets target currency from convert" do
      convert = %{target_currency: "doge"}
      assert ConvertView.selected_currency("target", convert) == "doge"
    end
  end

  describe "Prediction functions" do
    setup do
      date = ~D[2016-06-01]
      amount = Decimal.new(1000)
      rates = [
        %{rate: Decimal.new(10), date: Ecto.Date.cast!(date)},
        %{rate: Decimal.new(20.0), date: Ecto.Date.cast!(Timex.shift(date, weeks: -1))},
        %{rate: Decimal.new(30.1), date: Ecto.Date.cast!(Timex.shift(date, weeks: -2))},
        %{rate: Decimal.new(40), date: Ecto.Date.cast!(Timex.shift(date, weeks: -3))}
      ]
      rate = Enum.max(rates).rate
      top_three = rates
                  |> Enum.sort(fn(x, y) -> x.rate > y.rate end)
                  |> Enum.slice(0..2)

      {:ok, amount: amount, rates: rates, rate: rate, top_three: top_three}
    end

    test "convert rates to json", %{amount: amount, rates: rates} do
      expected = """
      [{\"y\":\"20000\",\"x\":\"2016-06-15\"},\
      {\"y\":\"30000\",\"x\":\"2016-06-08\"},\
      {\"y\":\"40100\",\"x\":\"2016-06-01\"},\
      {\"y\":\"50000\",\"x\":\"2016-05-25\"}]
      """ |> String.trim

      assert ConvertView.json_rates(amount, rates, 2) == {:safe, expected}
    end

    test "return profit/loss", %{amount: amount, rates: rates, rate: rate} do
      assert ConvertView.profit_loss(amount, rate, rates) == Decimal.new(10000)
    end

    test "returns top three rates", %{rates: rates, top_three: top_three} do
      assert ConvertView.top_three_rates(rates) == top_three
    end
  end
end
