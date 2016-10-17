defmodule Stockman.Plug.EnsureAdmin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    admin_email = Application.get_env(:stockman, Stockman.Endpoint)[:admin_email]

    case current_user.email do
      ^admin_email ->
        conn
      _ ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(403, "Get the f... out!")
        |> halt
    end
  end
end
