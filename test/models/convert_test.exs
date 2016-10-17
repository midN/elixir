defmodule Stockman.ConvertTest do
  use Stockman.ModelCase

  alias Stockman.Convert

  @valid_attrs %{amount: "120.5", base_currency: "some content", target_currency: "some content", waiting_time: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Convert.changeset(%Convert{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Convert.changeset(%Convert{}, @invalid_attrs)
    refute changeset.valid?
  end
end
