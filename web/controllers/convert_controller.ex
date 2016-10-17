defmodule Stockman.ConvertController do
  use Stockman.Web, :controller

  alias Stockman.Convert

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    page_number = Map.get(params, "page", 1)
    page = user_converts(user)
               |> Repo.paginate(page: page_number, page_size: 5)

    render(conn, "index.html", converts: page.entries, page: page)
  end

  def new(conn, _params) do
    changeset = Guardian.Plug.current_resource(conn)
    |> build_assoc(:converts)
    |> Convert.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"convert" => convert_params}) do
    changeset = Guardian.Plug.current_resource(conn)
    |> build_assoc(:converts)
    |> Convert.changeset(convert_params)

    case Repo.insert(changeset) do
      {:ok, _convert} ->
        conn
        |> put_flash(:success, "Convert created successfully.")
        |> redirect(to: convert_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    convert = Repo.get!(Convert, id)

    if convert.user_id == conn.assigns.current_user.id do
      render(conn, "show.html", convert: convert)
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    convert = Repo.get!(Convert, id)

    if convert.user_id == conn.assigns.current_user.id do
      changeset = Convert.changeset(convert)
      render(conn, "edit.html", convert: convert, changeset: changeset)
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "convert" => convert_params}) do
    convert = Repo.get!(Convert, id)

    if convert.user_id == conn.assigns.current_user.id do
      changeset = Convert.changeset(convert, convert_params)
      case Repo.update(changeset) do
        {:ok, convert} ->
          conn
          |> put_flash(:success, "Convert updated successfully.")
          |> redirect(to: convert_path(conn, :show, convert))
        {:error, changeset} ->
          render(conn, "edit.html", convert: convert, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    convert = Repo.get!(Convert, id)

    if convert.user_id == conn.assigns.current_user.id do
      Repo.delete!(convert)

      conn
      |> put_flash(:error, "Convert deleted successfully.")
      |> redirect(to: convert_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def fetch_rates(conn, %{"convert_id" => convert_id}) do
    Exq.enqueue(Exq, "default", Stockman.RateFetcher, [])

    conn
    |> put_flash(:success, "Fetching rates started in the background.")
    |> redirect(to: convert_path(conn, :index))
  end

  defp user_converts(user) do
    from c in Convert,
      where: c.user_id == ^user.id,
      select: [:id, :base_currency, :target_currency, :amount, :waiting_time]
  end
end
