defmodule Stockman.RateTest do
  use Stockman.ModelCase

  alias Stockman.Rate

  @valid_attrs %{date: %{day: 17, month: 4, year: 2010}, rate: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Rate.changeset(%Rate{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Rate.changeset(%Rate{}, @invalid_attrs)
    refute changeset.valid?
  end
end
