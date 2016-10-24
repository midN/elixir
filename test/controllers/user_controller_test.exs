defmodule Stockman.UserControllerTest do
  use Stockman.ConnCase, async: true

  @moduletag :user_controller

  @valid_attrs %{
    email: "test@test.ee",
    password: "password", password_confirmation: "password"
  }
  @invalid_attrs %{}

  describe "user is logged in" do
    test "GET /users/new" do
      user = insert(:user)
      conn = guardian_login(user) |> get("/users/new")

      assert get_flash(conn, :danger) == "Already authenticated."
      assert redirected_to(conn) == "/converts"
    end
  end

  describe "user is not logged in" do
    test "GET /users/new" do
      conn = get(build_conn, "/users/new")
      assert html_response(conn, 200) =~ "Create new user"
    end

    test "POST /users with valid attrs" do
      conn = post(build_conn, "/users", user: @valid_attrs)

      assert get_flash(conn, :info) == "Welcome #{@valid_attrs.email}!"
      assert redirected_to(conn) == convert_path(conn, :index)
      assert Repo.get_by(Stockman.User, email: @valid_attrs.email)
    end

    test "POST /users with invalid attrs" do
      conn = post(build_conn, "/users", user: @invalid_attrs)

      assert html_response(conn, 200) =~ "Create new user"
    end
  end
end
