defmodule Stockman.Rate do
  use Stockman.Web, :model
  alias Stockman.Rate

  schema "rates" do
    field :date, Ecto.Date
    field :rate, :decimal
    belongs_to :convert, Stockman.Convert

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
    where: r.convert_id == ^convert_id
  end
end
