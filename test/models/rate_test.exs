defmodule Stockman.RateTest do
  use Stockman.ModelCase, async: true

  alias Stockman.Rate

  @moduletag :rate_model

  @valid_attrs %{date: %{day: 17, month: 4, year: 2010}, rate: "120.5"}
  @invalid_attrs %{}

  describe "Rate.changeset/2" do
    test "with valid attributes" do
      changeset = Rate.changeset(%Rate{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Rate.changeset(%Rate{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "Rate.convert_rates/1" do
    test "finds convert rates" do
      convert = insert(:convert, user: build(:user))
      assert Rate.convert_rates(convert.id) |> Repo.all |> Enum.count == 0

      insert(:rate, convert: convert)
      assert Rate.convert_rates(convert.id) |> Repo.all |> Enum.count == 1
    end
  end
end
