defmodule Stockman.FixerTest do
  use ExUnit.Case, async: true

  alias Stockman.Fixer

  @moduletag :fixer_service

  describe "Fixer.process_url/1" do
    test "returns fixer url" do
      url = "http://api.fixer.io/bla"
      assert Fixer.process_url("/bla") == url
    end
  end

  describe "Fixer.process_response_body/1" do
    test "processes response body" do
      body = "{\"base\":\"EUR\",\"date\":\"2015-12-31\",\"rates\":{\"USD\":1.0887}}"
      exp = [base: "EUR", date: "2015-12-31", rates: %{"USD" => 1.0887}]

      assert Fixer.process_response_body(body) == exp
    end
  end

  describe "Fixer.rates_url/3" do
    test "returns url with formatted date" do
      url = "/2016-01-01?base=EUR&symbols=USD"
      assert Fixer.rates_url(~D[2016-01-01], "EUR", "USD") == url
    end
  end
end
