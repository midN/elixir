defmodule Stockman.Plug.CurrentUser do
  @moduledoc false

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    Plug.Conn.assign(conn, :current_user, current_user)
  end
end
