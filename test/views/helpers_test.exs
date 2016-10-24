defmodule Stockman.HelpersTest do
  use Stockman.ConnCase, async: true

  alias Stockman.Helpers

  @moduletag :helper

  describe "Helpers.cartman_quote" do
    test "returns random quote from cartman" do
      assert Helpers.cartman_quote |> is_binary
    end
  end
end
