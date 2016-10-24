defmodule Stockman.LayoutView do
  use Stockman.Web, :view

  def get_flash_type(flash) do
    flash
    |> Tuple.to_list
    |> Enum.at(0)
  end

  def get_flash_msg(flash) do
    flash
    |> Tuple.to_list
    |> Enum.at(1)
  end
end
