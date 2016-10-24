defmodule Stockman.SessionController do
  use Stockman.Web, :controller

  def new(conn, _) do
    case Guardian.Plug.authenticated?(conn) do
      true ->
        conn
        |> put_flash(:danger, "Already authenticated.")
        |> redirect(to: convert_path(conn, :index))
      _ ->
        render conn, "new.html"
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case Stockman.User.find_and_confirm_pw(email, pass) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:success, "Logged in.")
        |> redirect(to: convert_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:danger, "Wrong email/password.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out.")
    |> redirect(to: "/")
  end
end
