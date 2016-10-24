defmodule Stockman.RateFetcher do
  @moduledoc false

  import Stockman.Router.Helpers
  alias Stockman.Endpoint
  alias Stockman.RateService

  def perform(user_id, convert_id) do
    # Elixir u too fast, had to add sleep in order to receive Channel msg
    :timer.sleep(200)

    url = convert_url(Endpoint, :show, convert_id)
    case RateService.get_and_process_rates(convert_id, :fixer) do
      {:ok, _msg} ->
        Endpoint.broadcast("users:#{user_id}", "message",
                           %{type: "success", link: url,
                             body: "Rates got fetched!"})
      {:error, _reason} ->
        Endpoint.broadcast("users:#{user_id}", "message",
                           %{type: "danger", link: url,
                             body: "Rate fetching failed, please try again."})

    end
  end
end
