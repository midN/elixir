defmodule Stockman.Rate do
  use Stockman.Web, :model
  alias Stockman.Rate
  alias Stockman.Convert

  schema "rates" do
    field :date, Ecto.Date
    field :rate, :decimal
    belongs_to :convert, Convert

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:date, :rate])
    |> validate_required([:date, :rate])
  end

  def convert_rates(convert_id) do
    from r in Rate,
      where: r.convert_id == ^convert_id,
      select: [:id, :date, :rate],
      order_by: [asc: :date]
  end

  def convert_rates_exist(convert_id) do
    from r in Rate,
      where: r.convert_id == ^convert_id,
      select: 1, limit: 1
  end

  def convert_rates_to_delete(convert_id) do
    from r in Rate,
    where: r.convert_id == ^convert_id
  end
end
