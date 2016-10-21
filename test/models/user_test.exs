defmodule Stockman.UserTest do
  use Stockman.ModelCase

  alias Stockman.User

  @moduletag :user_model

  @valid_attrs %{
    email: "test@test.ee",
    password: "password123", password_confirmation: "password123"
  }
  @invalid_attrs %{}

  describe "User.changeset/2" do
    test "valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = User.changeset(%User{}, @invalid_attrs)
      refute changeset.valid?
    end
  end

  describe "User.registration_changeset/2" do
    test "with valid attributes" do
      changeset = User.registration_changeset(%User{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = User.registration_changeset(%User{},
                                              Map.delete(@valid_attrs, :password))
      refute changeset.valid?
    end
  end

  describe "User.find_and_confirm_pw/2" do
    setup do
      user = insert(:user)
      {:ok, user: user}
    end

    test "exitising user and correct password", %{user: user} do
      confirmation = User.find_and_confirm_pw(user.email, user.password)
      assert {:ok, _} = confirmation
    end

    test "exitising user and incorrect password", %{user: user} do
      confirmation = User.find_and_confirm_pw(user.email, "bla")
      assert {:error, :unauthorized} = confirmation
    end

    test "user doesn't exist" do
      confirmation = User.find_and_confirm_pw("bla", "bla")
      assert {:error, :not_found} = confirmation
    end
  end
end
