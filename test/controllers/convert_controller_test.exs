defmodule Stockman.ConvertControllerTest do
  use Stockman.ConnCase, async: true

  alias Stockman.Convert
  @moduletag :convert_controller

  @valid_attrs %{amount: "120.5", base_currency: "EUR", target_currency: "USD", waiting_time: 42}
  @invalid_attrs %{amount: nil}

  setup do
    user = insert(:user)
    c1 = insert(:convert, user: user, base_currency: "VALERA")
    c2 = insert(:convert, base_currency: "NOT_VALERA")
    conn = guardian_login(user)

    {:ok, conn: conn, c1: c1, c2: c2}
  end

  test "GET /converts shows owned resources", %{conn: conn, c1: c1, c2: c2} do
    conn = get(conn, convert_path(conn, :index))

    assert html_response(conn, 200) =~ c1.base_currency
    refute html_response(conn, 200) =~ c2.base_currency
  end

  test "GET /converts/new", %{conn: conn} do
    conn = get(conn, convert_path(conn, :new))

    assert html_response(conn, 200) =~ "New convert"
  end

  describe "ConvertController.create/2" do
    test "POST /converts with valid params", %{conn: conn} do
      conn = post(conn, convert_path(conn, :create), convert: @valid_attrs)

      assert get_flash(conn, :success) == "Convert created successfully."
      assert redirected_to(conn) =~ "/converts/"
      assert Repo.get_by(Convert, @valid_attrs)
    end

    test "POST /converts with invalid params", %{conn: conn} do
      conn = post(conn, convert_path(conn, :create), convert: @invalid_attrs)

      assert html_response(conn, 200) =~ "New convert"
    end
  end

  describe "ConvertController.show/2" do
    test "GET /converts/:id when user owns convert", %{conn: conn, c1: c1} do
      conn = get(conn, convert_path(conn, :show, c1))

      assert html_response(conn, 200) =~ "Fetch rates"
    end

    test "GET /converts/:id when user doesnt own convert", %{conn: conn, c2: c2} do
      conn = get(conn, convert_path(conn, :show, c2))

      assert get_flash(conn, :danger) == "Access denied"
      assert redirected_to(conn) == convert_path(conn, :index)
    end
  end

  describe "ConvertController.edit/2" do
    test "GET /converts/:id/edit when user owns convert", %{conn: conn, c1: c1} do
      conn = get(conn, convert_path(conn, :edit, c1))

      assert html_response(conn, 200) =~ "Edit convert"
    end

    test "GET /converts/:id/edit when user doesnt own convert", %{conn: conn, c2: c2} do
      conn = get(conn, convert_path(conn, :edit, c2))

      assert get_flash(conn, :danger) == "Access denied"
      assert redirected_to(conn) == convert_path(conn, :index)
    end
  end

  describe "ConvertController.update/2" do
    test "PUT /converts/:id with valid params", %{conn: conn, c1: c1} do
      conn = put(conn, convert_path(conn, :update, c1), convert: @valid_attrs)

      assert get_flash(conn, :success) == "Convert updated successfully."
      assert redirected_to(conn) == convert_path(conn, :show, c1)
    end

    test "PUT /converts/:id with invalid params", %{conn: conn, c1: c1} do
      conn = put(conn, convert_path(conn, :update, c1), convert: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit convert"
    end

    test "PUT /converts/:id when user doesnt own convert", %{conn: conn, c2: c2} do
      conn = put(conn, convert_path(conn, :update, c2), convert: @invalid_attrs)

      assert get_flash(conn, :danger) == "Access denied"
      assert redirected_to(conn) == convert_path(conn, :index)
    end
  end

  describe "ConvertController.delete/2" do
    test "DELETE /converts/:id when user owns convert", %{conn: conn, c1: c1} do
      conn = delete(conn, convert_path(conn, :delete, c1))

      assert get_flash(conn, :danger) == "Convert deleted successfully."
      assert redirected_to(conn) == convert_path(conn, :index)
    end

    test "DELETE /converts/:id when user doesnt owns convert", %{conn: conn, c2: c2} do
      conn = delete(conn, convert_path(conn, :delete, c2))

      assert get_flash(conn, :danger) == "Access denied"
      assert redirected_to(conn) == convert_path(conn, :index)
    end
  end

  describe "ConvertController.fetch_rates/2" do
    test "GET /converts/:id/fetch_rates when rates exist", %{conn: conn, c1: c1} do
      insert(:rate, convert: c1)
      conn = get(conn, convert_ft_path(conn, :fetch_rates, c1))

      assert get_flash(conn, :danger) == "Rates already exist."
      assert redirected_to(conn) == convert_path(conn, :show, c1)
    end

    test "GET /converts/:id/fetch_rates when rates dont exist", %{conn: conn, c1: c1} do
      conn = get(conn, convert_ft_path(conn, :fetch_rates, c1))

      assert get_flash(conn, :success) == "Fetching rates started in the background."
      assert redirected_to(conn) == convert_path(conn, :index)
    end
  end

  test "GET /converts/:id/refetch_rates", %{conn: conn, c1: c1} do
    rate = insert(:rate, convert: c1)
    conn = get(conn, convert_ft_path(conn, :refetch_rates, c1))

    refute Repo.get(Stockman.Rate, rate.id)
    assert get_flash(conn, :success) == "Fetching rates started in the background."
    assert redirected_to(conn) == convert_path(conn, :index)
  end
end
