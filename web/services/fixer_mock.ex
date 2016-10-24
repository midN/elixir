defmodule Stockman.FixerMock do

  def start, do: nil

  def rates_url(_, _, target) do
    case target do
      "USD" ->
        "/working"
      "UZD" ->
        "/failing"
    end
  end

  def get(url) do
    amount = case url do
      "/working" ->
        1
      _ ->
        nil
    end

    {:ok, %{
      body:
        %{
          rates: %{"USD" => amount}
        }
      }
    }
  end
end
