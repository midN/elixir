defmodule Stockman.ErrorHelpersTest do
  use Stockman.ConnCase, async: true

  alias Stockman.ErrorHelpers

  @moduletag :error_helper

  describe "ErrorHelpers.error_tag/2" do
    test "returns content_tag with translated error" do
      form = %{errors: %{"bla" => {"such wow", %{}}}}
      assert match?({:safe, _}, ErrorHelpers.error_tag(form, "bla"))
    end
  end

  describe "ErrorHelpers.translate_error/1" do
    test "translates singular message" do
      error = {"wow", %{}}
      assert ErrorHelpers.translate_error(error) == "wow"
    end

    test "translates plural message" do
      error = {"%{count} wows", %{count: 5}}
      assert ErrorHelpers.translate_error(error) == "5 wows"
    end
  end
end
