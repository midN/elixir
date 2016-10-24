defmodule Stockman.LayoutViewTest do
  use Stockman.ConnCase, async: true

  alias Stockman.LayoutView

  @moduletag :layout_view

  describe "LayoutView.get_flash_type/1" do
    test "returns 0 element from provided Tuple" do
      flash = {"danger", "wow"}
      assert LayoutView.get_flash_type(flash) == "danger"
    end
  end

  describe "LayoutView.get_flash_msg/1" do
    test "returns 1 element from provided Tuple" do
      flash = {"danger", "wow"}
      assert LayoutView.get_flash_msg(flash) == "wow"
    end
  end
end
