defmodule Stockman.RateFetcher do
  def perform do
    :timer.sleep(5000)
    Stockman.Endpoint.broadcast("users:5", "message", %{body: "The fok?"})
  end
end
