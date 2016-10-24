defmodule Stockman.SessionControllerTest do
  use Stockman.ConnCase, async: true

  @moduletag :session_controller

  @valid_attrs %{email: "test@test.ee", password: "password123"}
  @invalid_attrs %{}

  describe "user is logged in" do
    test "GET /sessions/new" do
      user = insert(:user)
      conn = guardian_login(user) |> get("/sessions/new")

      assert get_flash(conn, :danger) == "Already authenticated."
      assert redirected_to(conn) == "/converts"
    end

    test "DELETE /sessions/:id" do
      user = insert(:user)
      conn = guardian_login(user)
      conn = delete(conn, session_path(conn, :delete, user))

      assert get_flash(conn, :info) == "Logged out."
      assert redirected_to(conn) == "/"
    end
  end

  describe "user is not logged in" do
    test "GET /sessions/new" do
      conn = get(build_conn, "/sessions/new")

      assert html_response(conn, 200) =~ "Sign in"
    end

    test "POST /sessions with valid attributes" do
      insert(:user)
      conn = post(build_conn, "/sessions", session: @valid_attrs)

      assert get_flash(conn, :success) == "Logged in."
      assert redirected_to(conn) == convert_path(conn, :index)
    end

    test "POST /sessions with invalid attributes" do
      conn = post(build_conn, "/sessions", session: @valid_attrs)

      assert get_flash(conn, :danger) == "Wrong email/password."
      assert html_response(conn, 200) =~ "Sign in"
    end
  end
end
