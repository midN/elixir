defmodule Stockman.ConvertControllerTest do
  use Stockman.ConnCase

  alias Stockman.Convert
  @valid_attrs %{amount: "120.5", base_currency: "some content", target_currency: "some content", waiting_time: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, convert_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing converts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, convert_path(conn, :new)
    assert html_response(conn, 200) =~ "New convert"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, convert_path(conn, :create), convert: @valid_attrs
    assert redirected_to(conn) == convert_path(conn, :index)
    assert Repo.get_by(Convert, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, convert_path(conn, :create), convert: @invalid_attrs
    assert html_response(conn, 200) =~ "New convert"
  end

  test "shows chosen resource", %{conn: conn} do
    convert = Repo.insert! %Convert{}
    conn = get conn, convert_path(conn, :show, convert)
    assert html_response(conn, 200) =~ "Show convert"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, convert_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    convert = Repo.insert! %Convert{}
    conn = get conn, convert_path(conn, :edit, convert)
    assert html_response(conn, 200) =~ "Edit convert"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    convert = Repo.insert! %Convert{}
    conn = put conn, convert_path(conn, :update, convert), convert: @valid_attrs
    assert redirected_to(conn) == convert_path(conn, :show, convert)
    assert Repo.get_by(Convert, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    convert = Repo.insert! %Convert{}
    conn = put conn, convert_path(conn, :update, convert), convert: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit convert"
  end

  test "deletes chosen resource", %{conn: conn} do
    convert = Repo.insert! %Convert{}
    conn = delete conn, convert_path(conn, :delete, convert)
    assert redirected_to(conn) == convert_path(conn, :index)
    refute Repo.get(Convert, convert.id)
  end
end
