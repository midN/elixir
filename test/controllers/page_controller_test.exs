defmodule Stockman.PageControllerTest do
  use Stockman.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Hello Stockman!"
  end
end
