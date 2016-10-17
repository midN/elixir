defmodule Stockman.UserController do
  use Stockman.Web, :controller
  alias Stockman.User

  def new(conn, _params) do
    case Guardian.Plug.authenticated?(conn) do
      true ->
        conn
        |> put_flash(:error, "Already authenticated.")
        |> redirect(to: convert_path(conn, :index))
      _ ->
        changeset = User.changeset(%User{})
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Welcome #{user.email}!")
        |> redirect(to: convert_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render("new.html", changeset: changeset)
    end
  end
end
