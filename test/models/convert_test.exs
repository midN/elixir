defmodule Stockman.ConvertTest do
  use Stockman.ModelCase, async: true

  alias Stockman.Convert

  @moduletag :convert_model

  @valid_attrs %{
    amount: "120.5", base_currency: "EUR",
    target_currency: "USD", waiting_time: 42
  }
  @invalid_attrs %{
    amount: "120.5", base_currency: "EUR",
    target_currency: "EUR", waiting_time: 251
  }

  describe "User.changeset/2" do
    test "with valid attributes" do
      changeset = Convert.changeset(%Convert{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Convert.changeset(%Convert{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

   describe "User.allowed_currencies" do
     test "with valid currency" do
       assert "EUR" in Convert.allowed_currencies
     end

     test "with invalid currency" do
       refute "FAG" in Convert.allowed_currencies
     end
   end

   describe "Convert.user_converts/1" do
     test "returns Ecto.Query with converts found by user_id" do
       user = insert(:user)
       assert Convert.user_converts(user.id) |> Repo.all |> Enum.count == 0

       insert(:convert, user: user)
       assert Convert.user_converts(user.id) |> Repo.all |> Enum.count == 1
     end
   end
end
