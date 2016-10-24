defmodule Stockman.Convert do
  @moduledoc false

  use Stockman.Web, :model
  alias Stockman.Convert

  schema "converts" do
    field :base_currency, :string
    field :target_currency, :string
    field :amount, :decimal
    field :waiting_time, :integer
    belongs_to :user, Stockman.User
    has_many :rates, Stockman.Rate

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:base_currency, :target_currency, :amount, :waiting_time])
    |> validate_required([:base_currency, :target_currency, :amount, :waiting_time])
    |> validate_inclusion(:base_currency, allowed_currencies)
    |> validate_inclusion(:target_currency, allowed_currencies)
    |> validate_number(:amount, less_than: 2_147_483_648, greater_than: 0)
    |> validate_number(:waiting_time, greater_than: 0, less_than: 251)
    |> validate_currencies_differ()
  end

  def allowed_currencies do
    ~w(
       AUD BGN BRL CAD CHF CNY CZK DKK EUR GBP HKD
       HRK HUF IDR ILS INR JPY KRW MXN MYR NOK NZD
       PHP PLN RON RUB SEK SGD THB TRY USD ZAR
     )
  end

  def user_converts(user_id) do
    from c in Convert,
      where: c.user_id == ^user_id,
      select: [:id, :base_currency, :target_currency, :amount, :waiting_time]
  end

  defp validate_currencies_differ(changeset) do
    base = get_field(changeset, :base_currency)
    target = get_field(changeset, :target_currency)

    validate_currencies_differ(changeset, base, target)
  end
  defp validate_currencies_differ(changeset, base, target) when base == target do
    add_error(changeset, :currencies, "Base and Target must be different.")
  end
  defp validate_currencies_differ(changeset, _, _), do: changeset
end
