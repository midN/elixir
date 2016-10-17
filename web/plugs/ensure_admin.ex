defmodule Stockman.Plug.EnsureAdmin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    current_user = Guardian.Plug.current_resource(conn)
    case current_user.email do
      "andres@andres.wtf" ->
        conn
      _ ->
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(403, "Get the f... out!")
        |> halt
    end
  end
end
