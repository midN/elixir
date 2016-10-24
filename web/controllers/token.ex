defmodule Stockman.Token do
  @moduledoc false

  use Stockman.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:info, "You must be signed in to access this page")
    |> redirect(to: session_path(conn, :new))
  end
end
