defmodule Stockman.UserChannel do
  use Phoenix.Channel

  def join("users:" <> user_id, _params, socket) do
    {user_id, _} = Integer.parse(user_id)

    case socket.assigns[:current_user_id] == user_id do
      true ->
        {:ok, socket}
      false ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: body}
    {:noreply, socket}
  end

  def handle_out("message", payload, socket) do
    push socket, "message", payload
    {:noreply, socket}
  end
end
