defmodule Stockman.PageController do
  use Stockman.Web, :controller

  def index(conn, _params) do
    if conn.assigns.current_user do
      redirect(conn, to: convert_path(conn, :index))
    else
      render conn, "index.html"
    end
  end
end
