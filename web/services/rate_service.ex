defmodule Stockman.RateService do
  import Ecto, only: [build_assoc: 2]

  alias Stockman.Repo
  alias Stockman.Convert
  alias Stockman.Rate

  @fixer Application.get_env(:stockman, :fixer_api)

  def get_and_process_rates(convert_id, :fixer) do
    convert = Repo.get(Convert, convert_id)

    case convert do
      nil ->
        {:error, :record_not_found}
      _ ->
        rates = get_rates(
          convert.waiting_time, convert.base_currency,
          convert.target_currency, :fixer
        )

        Repo.transaction fn ->
          case process_rates(convert, rates, :fixer)
               |> Enum.any?(fn({a, _b}) -> a == :error end)
          do
            true ->
              Repo.rollback(:rate_inserting_failed)
            false ->
              {:ok, :inserted}
          end
        end
    end
  end

  def get_rates(weeks, base, target, :fixer) do
    @fixer.start

    for x <- 0..weeks do
      date = Timex.shift(Timex.today, weeks: -x)
      case @fixer.rates_url(date, base, target) |> @fixer.get() do
        {:ok, resp} ->
          {date, resp.body[:rates][target]}
        {:error, _reason} ->
          {date, nil}
      end
    end
  end

  def process_rates(convert, rates, :fixer) do
    for {date, rate} <- rates do
      build_assoc(convert, :rates)
      |> Rate.changeset(%{date: date, rate: rate})
      |> Repo.insert
    end
  end
end
