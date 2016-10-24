defmodule Stockman.TokenTest do
  use Stockman.ConnCase, async: true

  @moduletag :token_controller

  describe "Token.unauthenticated/2" do
    test "GET /converts" do
      conn = build_conn |> get("/converts")

      assert get_flash(conn, :info) == "You must be signed in to access this page"
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end
end
