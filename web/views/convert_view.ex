defmodule Stockman.ConvertView do
  use Stockman.Web, :view
  import Scrivener.HTML

  def allowed_currencies do
    Stockman.Convert.allowed_currencies
  end
end
