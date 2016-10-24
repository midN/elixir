defmodule Stockman.RateService do
  @moduledoc false

  import Ecto, only: [build_assoc: 2]

  alias Stockman.Repo
  alias Stockman.Convert
  alias Stockman.Rate

  @fixer Application.get_env(:stockman, :fixer_api)

  def get_and_process_rates(convert_id, :fixer) do
    c = Repo.get(Convert, convert_id)

    case c do
      nil ->
        {:error, :record_not_found}
      _ ->
        c.waiting_time
        |> get_rates(c.base_currency, c.target_currency, :fixer)
        |> process_rates(c, :fixer)
    end
  end

  def get_rates(weeks, base, target, :fixer) do
    @fixer.start

    weeks
    |> compute_dates
    |> build_urls(base, target)
    |> get_responses
    |> format_responses
  end

  def process_rates(rates, convert, :fixer) do
    Repo.transaction fn ->
      for {date, rate} <- rates do
        edate = Ecto.Date.cast!(date)

        convert
        |> build_assoc(:rates)
        |> Rate.changeset(%{date: edate, rate: rate})
        |> Repo.insert
      end
      |> insert_rates
    end
  end

  def compute_dates(weeks) do
    for i <- 0..weeks, do: Timex.shift(Timex.today, weeks: -i)
  end

  def build_urls(dates, base, target) do
    for i <- dates do
      %{target: target, date: i, url: @fixer.rates_url(i, base, target)}
    end
  end

  def get_responses(url_structs) do
    for i <- url_structs do
      %{target: i.target, date: i.date, resp: @fixer.get(i.url)}
    end
  end

  def format_responses(resp_structs) do
    for i <- resp_structs do
      case i.resp do
        {:ok, resp} ->
          {i.date, resp.body[:rates][i.target]}
        {:error, _reason} ->
          {i.date, nil}
      end
    end
  end

  def insert_rates(rates) do
    case Enum.any?(rates, fn({a, _b}) -> a == :error end) do
      true ->
        Repo.rollback(:rate_inserting_failed)
      false ->
        {:ok, :inserted}
    end
  end
end
