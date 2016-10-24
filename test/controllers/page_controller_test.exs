defmodule Stockman.PageControllerTest do
  use Stockman.ConnCase

  @moduletag :page_controller

  describe "user is not logged in" do
    test "GET /", %{conn: conn} do
      conn = get conn, "/"
      assert html_response(conn, 200) =~ "Hello Stockman!"
    end
  end

  describe "user is logged in" do
    test "GET /" do
      user = insert(:user)
      conn = guardian_login(user) |> get("/")

      assert redirected_to(conn) == "/converts"
    end
  end
end
