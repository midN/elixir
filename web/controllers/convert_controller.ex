defmodule Stockman.ConvertController do
  use Stockman.Web, :controller

  alias Stockman.Convert
  alias Stockman.Rate
  alias Stockman.RateFetcher

  @queue Application.get_env(:stockman, :queue)

  def index(conn, params) do
    user = conn.assigns.current_user
    page_number = Map.get(params, "page", 1)
    pages = Convert.user_converts(user.id)
               |> Repo.paginate(page: page_number, page_size: 5)

    render(conn, "index.html", converts: pages.entries, page: pages)
  end

  def new(conn, _params) do
    changeset = Convert.changeset(%Convert{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"convert" => convert_params}) do
    changeset = conn.assigns.current_user
                |> build_assoc(:converts)
                |> Convert.changeset(convert_params)

    case Repo.insert(changeset) do
      {:ok, convert} ->
        conn
        |> put_flash(:success, "Convert created successfully.")
        |> redirect(to: convert_path(conn, :show, convert.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id} = params) do
    convert = Repo.get!(Convert, id)
    pages = rates(convert.id) |> Repo.paginate(page: Map.get(params, "page", 1))
    rates = rates(convert.id) |> Repo.all

    if convert.user_id == conn.assigns.current_user.id do
      render(
             conn, "show.html", convert: convert,
             rates: pages.entries, page: pages, all_rates: rates
           )
    else
      conn
      |> put_flash(:danger, "Access denied")
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
      |> put_flash(:danger, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def update(conn, %{"id" => id, "convert" => convert_params}) do
    convert = Repo.get!(Convert, id)

    if convert.user_id == conn.assigns.current_user.id do
      changeset = Convert.changeset(convert, convert_params)
      case Repo.update(changeset) do
        {:ok, convert} ->
          Rate.convert_rates(convert.id)
          |> Repo.delete_all

          conn
          |> put_flash(:success, "Convert updated successfully.")
          |> redirect(to: convert_path(conn, :show, convert))
        {:error, changeset} ->
          render(conn, "edit.html", convert: convert, changeset: changeset)
      end
    else
      conn
      |> put_flash(:danger, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    convert = Repo.get!(Convert, id)

    if convert.user_id == conn.assigns.current_user.id do
      Repo.delete!(convert)

      conn
      |> put_flash(:danger, "Convert deleted successfully.")
      |> redirect(to: convert_path(conn, :index))
    else
      conn
      |> put_flash(:danger, "Access denied")
      |> redirect(to: convert_path(conn, :index))
    end
  end

  def fetch_rates(conn, %{"convert_id" => convert_id}) do
    case rates_exist?(convert_id) do
      true ->
        conn
        |> put_flash(:danger, "Rates already exist.")
        |> redirect(to: convert_path(conn, :show, convert_id))
      false ->
        conn
        |> enqueue_rate_fetching(convert_id)
        |> put_flash(:success, "Fetching rates started in the background.")
        |> redirect(to: convert_path(conn, :index))
    end
  end

  def refetch_rates(conn, %{"convert_id" => convert_id}) do
    Rate.convert_rates(convert_id)
    |> Repo.delete_all

    conn
    |> enqueue_rate_fetching(convert_id)
    |> put_flash(:success, "Fetching rates started in the background.")
    |> redirect(to: convert_path(conn, :index))
  end

  defp rates(convert_id) do
    Rate.convert_rates(convert_id)
    |> Ecto.Query.select([:id, :date, :rate])
    |> Ecto.Query.order_by([asc: :date])
  end

  defp rates_exist?(convert_id) do
    Rate.convert_rates(convert_id)
    |> Ecto.Query.select(1)
    |> Ecto.Query.limit(1)
    |> Repo.all
    |> Enum.any?
  end

  defp enqueue_rate_fetching(conn, convert_id) do
    user_id = conn.assigns.current_user.id
    @queue.enqueue(Exq, "default", RateFetcher, [user_id, convert_id])
    conn
  end
end
