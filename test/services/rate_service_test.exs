defmodule Stockman.RateServiceTest do
  use Stockman.ModelCase, async: true

  alias Stockman.RateService

  @moduletag :rate_service

  describe "RateService.get_and_process_rates/2" do
    test "returns error tuple if convert not found" do
      tuple = {:error, :record_not_found}
      assert ^tuple = RateService.get_and_process_rates(1, :fixer)
    end

    test "fetches and inserts rates if convert found" do
      convert = insert(:convert, waiting_time: 2, target_currency: "USD")
      tuple = {:ok, {:ok, :inserted}}

      assert ^tuple = RateService.get_and_process_rates(convert.id, :fixer)
      assert Repo.all(Stockman.Rate) |> Enum.count == 3
    end

    test "rollbacks transaction if rates fetching failed" do
      convert = insert(:convert, waiting_time: 2, target_currency: "UZD")
      tuple = {:error, :rate_inserting_failed}

      assert ^tuple = RateService.get_and_process_rates(convert.id, :fixer)
    end
  end
end
