defmodule Stockman.Fixer do
  use HTTPoison.Base

  @expected_fields ~w(base date rates)

  def process_url(url), do: "http://api.fixer.io" <> url

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Map.take(@expected_fields)
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

  def rates_url(date, base, target) do
    "/" <> formatted_date(date)
    <> "?base=" <> base
    <> "&symbols=" <> target
  end

  defp formatted_date(date) do
    date
    |> Timex.format!("%Y-%m-%d", :strftime)
  end
end
